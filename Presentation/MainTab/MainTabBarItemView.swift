//
//  MainTabBarItemView.swift
//  ABZUsers
//
//  Created by Igor Karyi on 30.07.2025.
//

import SwiftUI

struct TabBarItemView: View {
    let tab: MainTab
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Offset.small) {
                Image(isSelected ? tab.iconSelectedName : tab.iconName)

                Text(tab.title.localizedString)
                    .font(.appFont(weight: .semiBold, size: 16))
                    .foregroundColor(isSelected ? .appSecondary : .appTabbarElement)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
