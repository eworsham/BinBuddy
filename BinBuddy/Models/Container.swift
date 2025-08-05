//
//  Container.swift
//  BinBuddy
//
//  Created by Ryan Worsham on 7/27/25.
//
import Foundation
import FirebaseFirestore

// Struct that respresents a container
struct Container: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var createdAt: Date
    var items: [Item] = []
    
    init(name: String, createdAt: Date = .now) {
        self.name = name
        self.createdAt = createdAt
    }
}
