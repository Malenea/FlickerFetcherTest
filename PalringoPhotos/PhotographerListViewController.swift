//
//  PhotographersListViewController.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 22/08/2020.
//  Copyright © 2020 Palringo. All rights reserved.
//

import Foundation
import UIKit

class PhotographersListViewController: UIViewController {

    var completion: (() -> Void)?

    private lazy var blurEffectView = makeBlurEffectView()
    private lazy var containerView = makeContainerView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var listView = makeListView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

}

private extension PhotographersListViewController {

    func setupUI() {
        view.addSubview(blurEffectView)
        view.addSubview(titleLabel)
        view.addSubview(containerView)
        containerView.addSubview(listView)
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 48.0),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 48.0),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48.0),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -96.0),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 48.0),

            listView.topAnchor.constraint(equalTo: containerView.topAnchor),
            listView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            listView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
        ])
    }

}

private extension PhotographersListViewController {

    func makeBlurEffectView() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
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
        label.text = "Choose a photographer"
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
        listView.distribution = .fillEqually
        listView.alignment = .center
        listView.spacing = 48.0
        for photographer in Photographers.allCases {
            let button = UIButton()
            button.setTitleColor(.white, for: .normal)
            button.setTitle(photographer.displayName, for: .normal)
            button.addTarget(self, action: #selector(tappedOnPhotographer), for: .touchUpInside)
            listView.addArrangedSubview(button)
        }
        return listView
    }

}
