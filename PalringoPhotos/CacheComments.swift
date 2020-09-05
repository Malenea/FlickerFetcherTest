//
//  CacheComments.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 05/09/2020.
//  Copyright © 2020 Palringo. All rights reserved.
//

import Foundation

class CacheComments {

    static let shared = CacheComments()

    let cache = NSCache<NSString, Comments>()

    func getCachedComment(with id: NSString) -> Comments? {
        if let cachedVersion = cache.object(forKey: id) {
            return cachedVersion
        }
        return nil
    }

    func setCachedComment(with id: NSString, comments: Comments) {
        cache.setObject(comments, forKey: id)
    }

}
