//
//  PhotoCollectionViewController.swift
//  PalringoPhotos
//
//  Created by Benjamin Briggs on 14/10/2016.
//  Copyright © 2016 Palringo. All rights reserved.
//

import UIKit

class PhotoCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = PhotographersInstance.shared.currentPhotographer.displayName
        imageView.download(from: PhotographersInstance.shared.currentPhotographer.imageURL)
        PhotographersInstance.shared.notifier = { [weak self] photographer in
            self?.title = photographer.displayName
            self?.imageView.download(from: photographer.imageURL)
        }
        PhotographersInstance.shared.presenter = { [weak self] in
            let photographersListViewController = PhotographersListViewController()
            self?.present(photographersListViewController, animated: true, completion: nil)
            photographersListViewController.completion = {
                photographersListViewController.dismiss(animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { [weak self] context in
            self?.collectionView?.collectionViewLayout.invalidateLayout()
        }, completion: nil)
        
        super.viewWillTransition(to: size, with: coordinator)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let commentsViewController = CommentsDetailsViewController()
        commentsViewController.photo = PhotographersInstance.shared.photos[indexPath.section][indexPath.row]
//        if #available(iOS 13, *) {
            //
//        } else {
//        }
        present(commentsViewController, animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 200)
    }

}
