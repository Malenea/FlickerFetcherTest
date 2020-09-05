//
//  PhotoDetailsViewController.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 05/09/2020.
//  Copyright © 2020 Palringo. All rights reserved.
//

import Foundation
import UIKit

final class PhotoDetailsViewController: UIViewController {

    public var coordinator: Coordinator?

    private var fetchTask: URLSessionTask? {
        willSet {
            fetchTask?.cancel()
        }
    }

    var photo: Photo? {
        didSet {
            guard let photo = photo else { return }
            self.fetchTask = CachedRequest.request(url: photo.url) { data, _ in
                guard let data = data else { return }
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.backgroundPhotoImageView.image = image
                    self.photoImageView.image = image
                }
            }
        }
    }

    private lazy var backgroundPhotoImageView = makeBackgroundPhotoImageView()
    private lazy var blurView = makeBlurView()
    private lazy var photoImageView = makePhotoImageView()
    private lazy var commentsButton = makeCommentsButton()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    deinit {
        print("💖 De-initiated photo details view controller")
    }

}

extension PhotoDetailsViewController {

    @objc func tappedOnComments(_ sender: AnyObject) {
        guard let photo = photo else { return }
        coordinator?.moveToCommentsDetailsViewController(with: photo)
    }

}

private extension PhotoDetailsViewController {

    func setupUI() {
        navigationItem.rightBarButtonItem = commentsButton

        view.prepareSubviewsForAutolayout(backgroundPhotoImageView, blurView, photoImageView)
        NSLayoutConstraint.activate([
            backgroundPhotoImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundPhotoImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundPhotoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundPhotoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            photoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),
            photoImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
            photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0)
        ])
    }

}

private extension PhotoDetailsViewController {

    func makeBackgroundPhotoImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }


    func makeBlurView() -> UIView {
        let view = UIView()
        view.blurView()
        return view
    }

    func makePhotoImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    func makeCommentsButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(title: "Comments", style: .plain, target: self, action: #selector(tappedOnComments))
        button.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)], for: .normal)
        button.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)], for: .highlighted)
        return button
    }

}
