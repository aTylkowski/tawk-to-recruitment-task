//
//  TitledText.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 25/07/2024.
//

import SwiftUI

struct TitledText: View {
    var title: String
    var text: String

    var body: some View {
        HStack {
            Text(title)
                .font(.poppinsBold(size: 14))
                .foregroundColor(.black)
            Spacer()
            Text(text)
                .font(.poppinsSemiBold(size: 14))
                .foregroundColor(.black)
        }
    }
}
