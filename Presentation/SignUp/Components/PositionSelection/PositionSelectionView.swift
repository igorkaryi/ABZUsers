//
//  PositionSelectionView.swift
//  ABZUsers
//
//  Created by Igor Karyi on 31.07.2025.
//

import SwiftUI

struct PositionSelectionView: View {
    let positions: [UserPosition]
    
    @Binding var selectedPositionId: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: Offset.standard) {
            Text("select_your_position".localizedString)
                .font(.appFont(weight: .regular, size: 18))
                .foregroundStyle(.appMainText)

            ForEach(positions) { position in
                Button {
                    selectedPositionId = position.id
                } label: {
                    HStack(spacing: Offset.medium) {
                        Image(selectedPositionId == position.id
                              ? "radio_button_selected_icon"
                              : "radio_button_icon"
                        )
                        .resizable()
                        .frame(width: 14, height: 14)

                        Text(position.name)
                            .font(.appFont(weight: .regular, size: 16))
                            .foregroundStyle(.appMainText)

                        Spacer(minLength: 0)
                    }
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, Offset.standard)
        }
        .onAppear {
            if let first = positions.first {
                selectedPositionId = first.id
            }
        }
    }
}
