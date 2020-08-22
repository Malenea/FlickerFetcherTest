//
//  UIImageView+Extensions.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 22/08/2020.
//  Copyright © 2020 Palringo. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {

    func download(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            self?.contentMode = mode
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200, let mimeType = response?.mimeType, mimeType.hasPrefix("image"), let data = data, error == nil, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async() { [weak self] in
                guard let self = self else { return }
                UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.image = image
                }) { _ in
                    completion?()
                }
            }
        }.resume()
    }

}
