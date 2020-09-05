//
//  UIView+Extensions.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 19/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    func roundView(with value: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = value
    }

    func blurView(isLight: Bool = false) {
        backgroundColor = .clear

        let blurEffect = UIBlurEffect(style: isLight ? .light : .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        prepareSubviewsForAutolayout(blurEffectView)
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func fadeIn(with duration: TimeInterval = 0.5) {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: duration) {
                self?.alpha = 1.0
            }
        }
    }

    func fadeOut(with duration: TimeInterval = 0.5) {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: duration) {
                self?.alpha = 0.0
            }
        }
    }

    func prepareSubviewsForAutolayout(_ subviews: UIView...) {
        prepareSubviewsForAutolayout(subviews)
    }

    func prepareSubviewsForAutolayout(_ subviews: [UIView]) {
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

}
