//
//  Item.swift
//  BinBuddy
//
//  Created by Ryan Worsham on 7/23/25.
//

import Foundation
import FirebaseFirestore

// Struct that represents an item
struct Item: Codable, Identifiable {
    @DocumentID var id : String?
    var name: String
    var timestamp: Date
    var container: Container?
    
    init(name: String, timestamp: Date = .now, container: Container? = nil) {
        self.name = name
        self.timestamp = timestamp
        self.container = container
    }
}
