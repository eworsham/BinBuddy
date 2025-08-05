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

    // Container List View
    var body: some View {
        NavigationStack {
            AppHeader(subtitle: "Containers")
            
            ZStack(alignment: .bottomTrailing) {
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
                                    Text("\(container.items.count) Items")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("Created at \(container.createdAt.formatted())")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .onDelete { offsets in
                            Task {
                                deleteContainers(offsets: offsets)
                                await loadContainers()
                            }
                        }
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
        }
    }
    
    // Function for displaying prompt to grab container name
    private func promptForContainerName() {
        isShowingContainerAlert = true
    }
    
    // Function to load all containers
    private func loadContainers() async {
        let fetched = await firestoreService.fetchAllContainers()
        withAnimation {
            containers = fetched
        }
    }

    // Function to add a new container
    private func addContainer(name: String) {
        let newContainer = Container(name: name)
        firestoreService.addContainer(container: newContainer)
    }

    // Function to delete an existing container
    private func deleteContainers(offsets: IndexSet) {
        for index in offsets {
            let containerToDelete = containers[index]
            guard let id = containerToDelete.id else {
                print( "Error deleting container: Missing ID.")
                continue
            }
            firestoreService.deleteContainer(id: id)
        }
    }
}

// Preview for development and debugging
#Preview {
    ContainerListView()
}
