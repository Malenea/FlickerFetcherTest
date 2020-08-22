//
//  CommentsDetailsViewController.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 22/08/2020.
//  Copyright © 2020 Palringo. All rights reserved.
//

import Foundation
import UIKit

class CommentsDetailsViewController: UIViewController {

    private var fetchTask: URLSessionTask? {
        willSet {
            fetchTask?.cancel()
        }
    }

    var completion: (() -> Void)?
    var photo: Photo? {
        didSet {
            guard let photo = photo else { return }
            self.fetchTask = CachedRequest.request(url: photo.url) { [weak self] data, isCached in
                    guard let self = self, data != nil else { return }
                    let img = UIImage(data: data!)
                    if isCached {
                        self.imageView.image = img
                    } else if self.photo == photo {
                        // UI modifications should be done from main thread
                        DispatchQueue.main.async {
                            UIView.transition(with: self.imageView, duration: 1, options: .transitionCrossDissolve, animations: {
                                self.imageView.image = img
                            }, completion: nil)
                        }
                    }
            }

            FlickrFetcher().getPhotoComments(for: photo) { [weak self] comments in
                if comments.isEmpty {
                    let label = UILabel()
                    label.text = "No comments"
                    self?.listView.addArrangedSubview(label)
                } else {
                    for comment in comments {
                        let label = UILabel()
                        label.numberOfLines = 0
                        label.attributedText = comment.comment.htmlToAttributedString
                        self?.listView.addArrangedSubview(label)
                    }
                }
            }
        }
    }

    private lazy var blurEffectView = makeBlurEffectView()
    private lazy var backButton = makeBackButton()
    private lazy var imageView = makeImageView()
    private lazy var containerView = makeContainerView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var listView = makeListView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    @objc func tappedOnBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}

private extension CommentsDetailsViewController {

    func setupUI() {
        view.addSubview(blurEffectView)
        view.addSubview(backButton)
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        view.addSubview(containerView)
        containerView.addSubview(listView)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 48.0),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),

            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            containerView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16.0),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 48.0),

            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8.0),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8.0),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            listView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0),
            listView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            listView.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -32.0),
            listView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }

}

private extension CommentsDetailsViewController {

    func makeBlurEffectView() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }

    func makeBackButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_back"), for: .normal)
        button.addTarget(self, action: #selector(tappedOnBack), for: .touchUpInside)
        return button
    }

    func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    func makeContainerView() -> UIScrollView {
        let containerView = UIScrollView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }

    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
        label.text = "Comments"
        return label
    }

    @objc func tappedOnPhotographer(_ sender: UIButton) {
        for photographer in Photographers.allCases where photographer.displayName == sender.title(for: .normal) {
            PhotographersInstance.shared.currentPhotographer = photographer
            completion?()
        }
    }

    func makeListView() -> UIStackView {
        let listView = UIStackView()
        listView.translatesAutoresizingMaskIntoConstraints = false
        listView.axis = .vertical
        listView.distribution = .fillProportionally
        listView.alignment = .leading
        listView.spacing = 16.0
        return listView
    }

}
