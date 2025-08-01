//
//  EmptyUsersView.swift
//  ABZUsers
//
//  Created by Igor Karyi on 31.07.2025.
//

import SwiftUI

struct EmptyUsersView: View {
    var body: some View {
        VStack {
            Spacer()
            StateView(
                imageName: "no_users_yet_icon",
                message: "there_are_no_users_yet".localizedString
            )
            Spacer()
        }
    }
}
