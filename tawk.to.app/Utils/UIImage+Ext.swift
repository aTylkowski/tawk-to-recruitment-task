//
//  UIImage+Ext.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 25/07/2024.
//

import UIKit

extension UIImage {
    func inverted() -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }
        let filter = CIFilter(name: "CIColorInvert")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)

        guard let outputImage = filter?.outputImage else { return nil }
        let context = CIContext(options: nil)

        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }

        return UIImage(cgImage: cgImage)
    }
}
