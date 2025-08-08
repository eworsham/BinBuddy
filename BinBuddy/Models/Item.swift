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
    var containerID: String?
    
    init(id: String? = nil, name: String, timestamp: Date = .now, containerID: String) {
        self.id = id
        self.name = name
        self.timestamp = timestamp
        self.containerID = containerID
    }
}
