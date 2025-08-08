//
//  FirestoreService.swift
//  BinBuddy
//
//  Created by Ryan Worsham on 8/4/25.
//

import Foundation
import FirebaseFirestore

// Class for the Firebase Firestore database functions
class FirestoreService {
    private let db = Firestore.firestore()

    // Function for adding a new container
    func addContainer(container: Container) {
        do {
            try db.collection("containers").addDocument(from: container)
        } catch {
            print("Error creating new container: \(error)")
        }
    }

    // Function for getting all containers
    func fetchAllContainers() async -> [Container] {
        do {
            let querySnapshot = try await db.collection("containers").getDocuments()
            let containers = querySnapshot.documents.compactMap { doc in
                try? doc.data(as: Container.self)
            }
            return containers
        } catch {
            print("Error getting all containers: \(error)")
            return []
        }
    }
    
    // Function to get container by id
    func fetchContainer(id: String) async -> Container? {
        do {
            let document = try await db.collection("containers").document(id).getDocument()
            return try document.data(as: Container.self)
        } catch {
            print("Error getting container by id: \(error)")
            return nil
        }
    }
    
    // Function for updating a container's name
    func editContainerName(id: String, newName: String) {
        db.collection("containers").document(id).updateData(["name": newName]) { error in
            if let error = error {
                print("Error updating container: \(error.localizedDescription)")
            }
        }
    }
    
    // Function for deleting a container
    func deleteContainer(id: String) {
        db.collection("containers").document(id).delete() { error in
            if let error = error {
                print("Error deleting container: \(error.localizedDescription)")
            }
        }
    }
    
    // Function for creating an item
    func addItem(item: Item) {
        do {
            try db.collection("items").addDocument(from: item)
        } catch {
            print("Error creating new item: \(error)")
        }
    }
    
    // Function for getting all items for a container by containerID
    func fetchAllItems(for containerID: String) async throws -> [Item] {
        let snapshot = try await db.collection("items")
            .whereField("containerID", isEqualTo: containerID)
            .getDocuments()

        return try snapshot.documents.map { try $0.data(as: Item.self) }
    }
    
    // Function for getting an item by id
    func fetchItemByID(id: String) async -> Item? {
        do {
            let document = try await db.collection("items").document(id).getDocument()
            return try document.data(as: Item.self)
        } catch {
            print("Error getting item by id: \(error)")
            return nil
        }
    }
    
    // Function for updating an item's name
    func editItemName(id: String, newName: String) {
        db.collection("items").document(id).updateData(["name": newName]) { error in
            if let error = error {
                print("Error updating item: \(error.localizedDescription)")
            }
        }
    }
    
    // Function for deleting an item
    func deleteItem(id: String) {
        db.collection("items").document(id).delete() { error in
            if let error = error {
                print("Error deleting item: \(error.localizedDescription)")
            }
        }
    }
}
