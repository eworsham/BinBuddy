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
            print(error)
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
            print("Error getting documents: \(error)")
            return []
        }
    }
    
    // Function for editing a container's name
    func editContainerName(id: String, newName: String) {
        db.collection("containers").document(id).updateData(["name": newName]) { error in
            if let error = error {
                print("Error updating container: \(error.localizedDescription)")
            }
        }
    }
    
    // Function for deleteing a container
    func deleteContainer(id: String) {
        db.collection("containers").document(id).delete() { error in
            if let error = error {
                print("Error deleting container: \(error.localizedDescription)")
            }
        }
    }
}
