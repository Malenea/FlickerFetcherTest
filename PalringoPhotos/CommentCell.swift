//
//  CommentCell.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 05/09/2020.
//  Copyright © 2020 Palringo. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    var comment: PhotoComment? {
        didSet {
            commentView.name = comment?.author.htmlAttributedString().with(font: UIFont.systemFont(ofSize: 12.0, weight: .semibold))
            commentView.comment = comment?.comment.htmlAttributedString().with(font: UIFont.systemFont(ofSize: 12.0, weight: .regular))
        }
    }

    private lazy var commentView = makeCommentView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

}

private extension CommentCell {

    func setupUI() {
        backgroundColor = .clear

        contentView.prepareSubviewsForAutolayout(commentView)
        NSLayoutConstraint.activate([
            commentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            commentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            commentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            commentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

}

private extension CommentCell {

    func makeCommentView() -> CommentView {
        let commentView = CommentView()
        return commentView
    }

}
