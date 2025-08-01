//
//  FullScreenLoader.swift
//  ABZUsers
//
//  Created by Igor Karyi on 01.08.2025.
//

import SwiftUI

struct FullScreenLoader: View {
    var body: some View {
        ZStack {
            Color.appSecondaryText
                .ignoresSafeArea()

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.2), value: UUID())
    }
}
