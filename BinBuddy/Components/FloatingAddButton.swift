//
//  FloatingAddButton.swift
//  BinBuddy
//
//  Created by Ryan Worsham on 7/27/25.
//

import SwiftUI

// View for the blue plus button used to add new containers and items
struct FloatingAddButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 30))
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.blue)
        .clipShape(Circle())
        .shadow(radius: 10)
    }
}

#Preview {
    FloatingAddButton(action: {})
}
