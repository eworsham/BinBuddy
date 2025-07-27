//
//  Container.swift
//  BinBuddy
//
//  Created by Ryan Worsham on 7/27/25.
//
import Foundation
import SwiftData

@Model
class Container {
    var name: String
    var createdAt: Date
    @Relationship(deleteRule: .cascade) var items: [Item] = []
    
    init(name: String, createdAt: Date = .now) {
        self.name = name
        self.createdAt = createdAt
    }
}
