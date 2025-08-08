//
//  ContainerDetailView.swift
//  BinBuddy
//
//  Created by Ryan Worsham on 7/27/25.
//
import SwiftUI

struct ContainerDetailView: View {
    private let firestoreService = FirestoreService()
    @State var container: Container
    @State var items: [Item] = []
    @State private var isShowingItemAlert = false
    @State private var newItemName = ""
    @State private var isShowingEditItemAlert = false
    @State private var itemBeingEdited: Item?
    @State private var updatedItemName = ""
    @State private var isLoading = false
    
    // Container Detail View
    var body: some View {
        AppHeader(subtitle: "\(container.name) (\(items.count) items)")
        
        ZStack(alignment: .bottomTrailing) {
            if isLoading && items.isEmpty {
                VStack {
                    Spacer()
                    ProgressView("Loading Items...")
                        .padding()
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground))
            } else {
                List {
                    if (items.isEmpty) {
                        Text("No Items Created")
                            .foregroundColor(.secondary)
                            .italic()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 40)
                    } else {
                        ForEach(items) { item in
                            Text(item.name)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        if let id = item.id {
                                            deleteItem(id: id)
                                            Task {
                                                await loadItems()
                                            }
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    
                                    Button {
                                        itemBeingEdited = item
                                        updatedItemName = item.name
                                        isShowingEditItemAlert = true
                                    } label : {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    .tint(.blue)
                                }
                        }
                    }
                }
                .refreshable {
                    await loadItems()
                }
            }
            FloatingAddButton(action: promptForItemName)
                .padding(.trailing, 30)
        }
        .task {
            await loadItems()
        }
        .alert("New Item", isPresented: $isShowingItemAlert, actions: {
            TextField("Item Name", text: $newItemName)
            Button("Add Item", action: {
                Task {
                    addItem(name: newItemName)
                    await loadItems()
                    newItemName = ""
                }
            })
            Button("Cancel", role: .cancel, action: {
                newItemName = ""
            })
        })
        .alert("Edit Item Name", isPresented: $isShowingEditItemAlert, actions: {
            TextField("Item Name", text: $updatedItemName)
            Button("Update", action: {
                Task {
                    if let item = itemBeingEdited, let id = item.id {
                        updateItemName(id: id, newName: updatedItemName)
                        Task {
                            await loadItems()
                        }
                        updatedItemName = ""
                        itemBeingEdited = nil
                    }
                }
            })
            Button("Cancel", role: .cancel, action: {
                updatedItemName = ""
                itemBeingEdited = nil
            })
        })
    }
    
    // Function for displaying the prompt to grab the new item name
    private func promptForItemName() {
        isShowingItemAlert = true
    }
    
    // Function for loading all items
    private func loadItems() async {
        guard let containerID = container.id else { return }
        isLoading = true
        do {
            let fetched = try await firestoreService.fetchAllItems(for: containerID)
            withAnimation {
                items = fetched
            }
        } catch {
            print("Failed to fetch items: \(error)")
        }
        isLoading = false
    }
    
    // Function for adding a new item
    private func addItem(name: String) {
        guard let containerID = container.id else {
            print("Error adding item: Missing container ID.")
            return
        }
        
        let newItem = Item(name: name, containerID: containerID)
        firestoreService.addItem(item: newItem)
    }
    
    // Function for deleting an item
    private func deleteItem(id: String) {
        firestoreService.deleteItem(id: id)
    }
    
    // Function for updating the container name
    func updateItemName(id: String, newName: String) {
        firestoreService.editItemName(id: id, newName: newName)
    }
}

// Preview for development and debugging
#Preview {
    ContainerListView()
}
