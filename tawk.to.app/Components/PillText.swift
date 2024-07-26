//
//  PillText.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 25/07/2024.
//

import SwiftUI

struct PillText: View {
    var text: String

    var body: some View {
        HStack {
            Text(text)
                .font(.poppinsBold(size: 12))
        }
        .padding(.horizontal, 9)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
