//
//  ImageCache.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 24/07/2024.
//

import UIKit

final class ImageCache {
    static let shared = ImageCache()

    private init() {}

    private let cache = NSCache<NSString, UIImage>()

    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
