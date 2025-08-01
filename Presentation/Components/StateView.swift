//
//  StateView.swift
//  ABZUsers
//
//  Created by Igor Karyi on 30.07.2025.
//

import SwiftUI

struct StateView: View {
    let imageName: String
    let message: String

    var body: some View {
        VStack(spacing: Offset.medium) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)

            Text(message)
                .font(.appFont(weight: .regular, size: 20))
                .foregroundStyle(.appMainText)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
