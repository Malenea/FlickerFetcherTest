//
//  CommentView.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 22/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation
import UIKit

final class CommentView: UIView {

    // Components
    private lazy var titleLabel = makeTitleLabel()
    private lazy var commentLabel = makeCommentLabel()

    // Control variables
    var name: NSAttributedString? {
        didSet {
            titleLabel.attributedText = name
        }
    }
    var comment: NSAttributedString? {
        didSet {
            commentLabel.attributedText = comment
        }
    }

    // Life cycle
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupUI()
    }

}

private extension CommentView {

    func setupUI() {
        roundView(with: 8.0)
        blurView(isLight: true)

        prepareSubviewsForAutolayout(titleLabel, commentLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0),

            commentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            commentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0),
            commentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            commentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0)
        ])
    }

}

private extension CommentView {

    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        return label
    }

    func makeCommentLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }

}
