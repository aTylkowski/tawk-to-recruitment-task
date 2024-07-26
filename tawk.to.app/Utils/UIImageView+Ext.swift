//
//  UIImageView+Ext.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 24/07/2024.
//

import UIKit

extension UIImageView {
    func setImage(from url: URL, placeholder: UIImage? = nil, isInverted: Bool = false) {
        self.image = placeholder

        if let cachedImage = ImageCache.shared.image(forKey: url.absoluteString) {
            self.image = cachedImage
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data), error == nil else { return }

            ImageCache.shared.setImage(image, forKey: url.absoluteString)

            DispatchQueue.main.async {
                self.image = isInverted ? image.inverted() : image
            }
        }
        .resume()
    }
}
