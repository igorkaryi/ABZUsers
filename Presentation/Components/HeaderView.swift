//
//  HeaderView.swift
//  ABZUsers
//
//  Created by Igor Karyi on 30.07.2025.
//

import SwiftUI

struct HeaderView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.appFont(weight: .regular, size: 20))
            .foregroundStyle(.appHeaderText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Offset.standard)
            .background(.appPrimary)
    }
}
