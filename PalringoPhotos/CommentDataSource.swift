//
//  CommentDataSource.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 05/09/2020.
//  Copyright © 2020 Palringo. All rights reserved.
//

import UIKit

class CommentDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

    static let reuseIdentifier = "CommentCell"

    public var tableView: UITableView?
    public var completion: ((Bool) -> Void)?

    private var photo: Photo?
    private lazy var comments = Comments()

    init(photo: Photo?) {
        self.photo = photo

        super.init()

        fetchComments()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        comments.value.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentDataSource.reuseIdentifier) as? CommentCell else {
            return UITableViewCell()
        }
        cell.comment = comments.value[indexPath.section]
        return cell
    }

    func fetchComments() {
        guard let photo = photo else { return }
        if let cachedVersion = CacheComments.shared.getCachedComment(with: photo.id as NSString) {
            comments = cachedVersion
            completion?(comments.value.isEmpty)
            tableView?.reloadData()
        } else {
            FlickrFetcher().getPhotoComments(for: photo) { [weak self] newComments in
                guard let self = self else { return }
                self.comments.value = newComments
                self.completion?(self.comments.value.isEmpty)
                self.tableView?.reloadData()
                CacheComments.shared.setCachedComment(with: photo.id as NSString, comments: self.comments)
            }
        }
    }

}
