//
//  Coordinator.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 05/09/2020.
//  Copyright © 2020 Palringo. All rights reserved.
//

import Foundation
import UIKit

final class Coordinator {

    var navigationController: UINavigationController

    func start() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let mainViewController = mainStoryboard.instantiateViewController(withIdentifier: "mainVC") as? PhotoCollectionViewController else {
            fatalError("Failed to load main view controller")
        }
        mainViewController.coordinator = self
        navigationController.pushViewController(mainViewController, animated: false)
    }

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

}

extension Coordinator {

    func moveToPhotographersList() {
        let photographersListViewController = PhotographersListViewController(currentPhotographer: PhotographersInstance.shared.currentPhotographer)
        navigationController.present(photographersListViewController, animated: true, completion: nil)
        photographersListViewController.completion = {
            photographersListViewController.dismiss(animated: true, completion: nil)
        }
    }

    func moveToPhotoDetailsViewController(with photo: Photo) {
        let photoDetailsViewController = PhotoDetailsViewController()
        photoDetailsViewController.coordinator = self
        photoDetailsViewController.photo = photo
        navigationController.pushViewController(photoDetailsViewController, animated: true)
    }

    func moveToCommentsDetailsViewController(with photo: Photo) {
        let commentsDetailsViewController = CommentsDetailsViewController()
        commentsDetailsViewController.photo = photo
        navigationController.pushViewController(commentsDetailsViewController, animated: true)
    }

}
