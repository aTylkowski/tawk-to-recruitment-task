//
//  UIFont+Ext.swift
//  etoto-ios-2
//
//  Created by Aleksy Tylkowski on 11/07/2024.
//

import UIKit
import CoreText

extension UIFont {
    static func poppins(size: CGFloat) -> UIFont {
        UIFont(name: "Poppins-Regular", size: size)!
    }

    static func poppinsLight(size: CGFloat) -> UIFont {
        UIFont(name: "Poppins-Light", size: size)!
    }

    static func poppinsMedium(size: CGFloat) -> UIFont {
        UIFont(name: "Poppins-Medium", size: size)!
    }

    static func poppinsSemiBold(size: CGFloat) -> UIFont {
        UIFont(name: "Poppins-SemiBold", size: size)!
    }

    static func poppinsBold(size: CGFloat) -> UIFont {
        UIFont(name: "Poppins-Bold", size: size)!
    }

    static func registerFonts() {
        ["Poppins-Regular",
         "Poppins-Light",
         "Poppins-Medium",
         "Poppins-SemiBold",
         "Poppins-Bold"].forEach {
            registerFont(ofName: $0)
        }
    }

    private static func registerFont(ofName resource: String) {
        guard let fontURL = Bundle.main.url(forResource: resource, withExtension: "ttf") else {
            print("Failed to find font file: \(resource)")
            return
        }

        do {
            let fontData = try Data(contentsOf: fontURL)
            guard let provider = CGDataProvider(data: fontData as CFData) else {
                print("Failed to create CGDataProvider for font: \(resource)")
                return
            }
            guard let font = CGFont(provider) else {
                print("Failed to create CGFont for font: \(resource)")
                return
            }

            var error: Unmanaged<CFError>?

            if !CTFontManagerRegisterGraphicsFont(font, &error), let error = error?.takeUnretainedValue() {
                let errorDescription = CFErrorCopyDescription(error) as String
                print("Failed to register font: \(errorDescription)")
            }
        } catch {
            print("Failed to load font data for \(resource): \(error)")
        }
    }
}
