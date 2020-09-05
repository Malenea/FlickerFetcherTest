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
            self.fetchTask = CachedRequest.request(url: photo.url) { [weak self] data, _ in
                guard let self = self, let data = data else { return }
                let image = UIImage(data: data)
                self.photoBackgroundImageView.image = image
            }
        }
    }

    private lazy var photoBackgroundImageView = makePhotoBackgroundImageView()
    private lazy var blurEffectView = makeBlurEffectView()
    private lazy var tableView = makeTableView()

    private lazy var emptyCommentsLabel = makeEmptyCommentsLabel()

    var datasource: CommentDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

}

private extension CommentsDetailsViewController {

    func setupUI() {
        navigationItem.title = "Comments"

        view.prepareSubviewsForAutolayout(photoBackgroundImageView, blurEffectView, tableView, emptyCommentsLabel)
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16.0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),

            emptyCommentsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyCommentsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyCommentsLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.8)
        ])
    }

}

private extension CommentsDetailsViewController {

    func makePhotoBackgroundImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }

    func makeBlurEffectView() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }

    func makeTableView() -> UITableView {
        let tableView = UITableView()
        datasource = CommentDataSource(photo: photo)
        datasource?.tableView = tableView
        datasource?.completion = { [weak self] isEmpty in
            if isEmpty {
                self?.emptyCommentsLabel.text = "There are no comments for this photo"
            } else {
                self?.emptyCommentsLabel.fadeOut(with: 0.25)
            }
        }
        tableView.dataSource = datasource
        tableView.delegate = self
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentDataSource.reuseIdentifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }

    func makeEmptyCommentsLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Fetching comments..."
        return label
    }

}

extension CommentsDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }

}
