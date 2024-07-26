//
//  Font+Ext.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 25/07/2024.
//

import SwiftUI

extension Font {
    static func poppins(size: CGFloat) -> Font {
        Font.custom("Poppins-Regular", size: size)
    }

    static func poppinsLight(size: CGFloat) -> Font {
        Font.custom("Poppins-Light", size: size)
    }

    static func poppinsMedium(size: CGFloat) -> Font {
        Font.custom("Poppins-Medium", size: size)
    }

    static func poppinsSemiBold(size: CGFloat) -> Font {
        Font.custom("Poppins-SemiBold", size: size)
    }

    static func poppinsBold(size: CGFloat) -> Font {
        Font.custom("Poppins-Bold", size: size)
    }
}

extension Font {
    init(uiFont: UIFont) {
        self = Font(uiFont as CTFont)
    }
}
