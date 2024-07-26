//
//  AsyncImage.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 24/07/2024.
//

import SwiftUI

struct AsyncImage: View {
    @State private var uiImage: UIImage?

    let url: URL
    let placeholder: UIImage = .avatar

    var body: some View {
        image
            .onAppear {
                loadImage()
            }
    }

    private var image: some View {
        Group {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(uiImage: placeholder)
                    .resizable()
            }
        }
    }

    private func loadImage() {
        if let cachedImage = ImageCache.shared.image(forKey: url.absoluteString) {
            uiImage = cachedImage
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data), error == nil else { return }

            ImageCache.shared.setImage(image, forKey: url.absoluteString)

            DispatchQueue.main.async {
                uiImage = image
            }
        }
        .resume()
    }
}
