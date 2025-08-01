//
//  PagingFooterView.swift
//  ABZUsers
//
//  Created by Igor Karyi on 31.07.2025.
//

import SwiftUI

struct PagingFooterView: View {
    var body: some View {
        HStack {
            Spacer()
            ProgressView()
                .progressViewStyle(.circular)
                .tint(.appSecondaryText)
            Spacer()
        }
        .padding(.vertical, Offset.standard)
        .background(.clear)
    }
}
