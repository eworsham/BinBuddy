//
//  ContainerListView.swift
//  BinBuddy
//
//  Created by Ryan Worsham on 7/23/25.
//

import SwiftUI

struct ContainerListView: View {
    private let firestoreService = FirestoreService()
    @State private var containers: [Container] = []
    @State private var isShowingContainerAlert = false
    @State private var newContainerName = ""
    @State private var itemCounts: [String: Int] = [:]
    @State private var isLoading = false
    @State private var isShowingEditAlert = false
    @State private var containerBeingEdited: Container?
    @State private var updatedContainerName = ""

    // Container List View
    var body: some View {
        NavigationStack {
            AppHeader(subtitle: "Containers")
            
            ZStack(alignment: .bottomTrailing) {
                if isLoading && containers.isEmpty {
                    VStack {
                        Spacer()
                        ProgressView("Loading Containers...")
                            .padding()
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGroupedBackground))
                } else {
                    List {
                        if (containers.isEmpty) {
                            Text("No Containers Created")
                                .foregroundColor(.secondary)
                                .italic()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, 40)
                        } else {
                            ForEach(containers) { container in
                                NavigationLink {
                                    ContainerDetailView(container: container)
                                } label: {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(container.name)
                                            .font(.headline)
                                        Text("\(itemCounts[container.id ?? ""] ?? 0) Items")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        if let id = container.id {
                                            Task {
                                                await deleteContainer(id: id)
                                                await loadContainers()
                                            }
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    
                                    Button {
                                        containerBeingEdited = container
                                        updatedContainerName = container.name
                                        isShowingEditAlert = true
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    .tint(.blue)
                                }
                            }
                        }
                    }
                    .refreshable {
                        await loadContainers()
                    }
                }
                FloatingAddButton(action: promptForContainerName)
                    .padding(.trailing, 30)
            }
            .background(Color(.systemGroupedBackground))
            .task {
                await loadContainers()
            }
            .alert("New Container", isPresented: $isShowingContainerAlert, actions: {
                TextField("Container Name", text: $newContainerName)
                Button("Add Container", action: {
                    Task {
                        addContainer(name: newContainerName)
                        await loadContainers()
                        newContainerName = ""
                    }
                })
                Button("Cancel", role: .cancel, action: {
                    newContainerName = ""
                })
            })
            .alert("Edit Container Name", isPresented: $isShowingEditAlert, actions: {
                TextField("Container Name", text: $updatedContainerName)
                Button("Update", action: {
                    if let container = containerBeingEdited, let id = container.id {
                        updateContainerName(id: id, name: updatedContainerName)
                        Task {
                            await loadContainers()
                        }
                        updatedContainerName = ""
                        containerBeingEdited = nil
                    }
                })
                Button("Cancel", role: .cancel, action: {
                    updatedContainerName = ""
                    containerBeingEdited = nil
                })
            })
        }
    }
    
    // Function for displaying prompt to grab container name
    private func promptForContainerName() {
        isShowingContainerAlert = true
    }
    
    // Function to load all containers
    private func loadContainers() async {
        isLoading = true
        let fetched = await firestoreService.fetchAllContainers()
        withAnimation {
            containers = fetched
        }
        await loadItemCounts(for: fetched)
        isLoading = false
    }

    // Function to add a new container
    private func addContainer(name: String) {
        let newContainer = Container(name: name)
        firestoreService.addContainer(container: newContainer)
    }
    
    // Function to update a container name
    private func updateContainerName(id: String, name: String) {
        firestoreService.editContainerName(id: id, newName: name)
    }

    // Function to delete an existing container
    private func deleteContainer(id: String) async {
        do {
            // Delete all items in container first
            let itemsToDelete = try await firestoreService.fetchAllItems(for: id)
            for item in itemsToDelete {
                if let itemId = item.id {
                    firestoreService.deleteItem(id: itemId)
                }
            }
            
            firestoreService.deleteContainer(id: id)
        } catch {
            
        }
    }
    
    // Function to load item counts for containers
    private func loadItemCounts(for containers: [Container]) async {
        var counts: [String: Int] = [:]
        for container in containers {
            if let id = container.id {
                do {
                    let items = try await firestoreService.fetchAllItems(for: id)
                    counts[id] = items.count
                } catch {
                    print("Failed to fetch items for container \(id): \(error)")
                    counts[id] = 0
                }
            }
        }
        itemCounts = counts
    }
}

// Preview for development and debugging
#Preview {
    ContainerListView()
}
