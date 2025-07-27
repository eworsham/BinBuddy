//
//  AppHeader.swift
//  BinBuddy
//
//  Created by Ryan Worsham on 7/27/25.
//

import SwiftUI

struct AppHeader: View {
    let subtitle: String
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 2) {
            Text("BinBuddy")
                .font(.title)
                .fontWeight(.bold)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground)
        )
    }
}
