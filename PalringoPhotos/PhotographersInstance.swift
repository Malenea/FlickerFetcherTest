//
//  PhotographersInstance.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 22/08/2020.
//  Copyright © 2020 Palringo. All rights reserved.
//

import Foundation

public class PhotographersInstance {

    var notifier: ((Photographers) -> Void)?
    var updater: (() -> Void)?
    var presenter: (() -> Void)?

    static var shared = PhotographersInstance()

    var currentPhotographer: Photographers = Photographers.dersascha {
        didSet {
            notifier?(currentPhotographer)
            updater?()
        }
    }
    var photographers: [Photographers] = []
    var photos: [[Photo]] = []

    init() {
        Photographers.allCases.forEach { [weak self] in self?.photographers.append($0) }
        if let photographer = photographers.first {
            currentPhotographer = photographer
        }
    }

}
