//
//  ListSeparator.swift
//  ABZUsers
//
//  Created by Igor Karyi on 31.07.2025.
//

import SwiftUI

struct ListSeparator: View {
    var body: some View {
        Rectangle()
            .foregroundStyle(.appSecondaryText.opacity(0.5))
            .frame(height: 1 / UIScreen.main.scale)
    }
}
