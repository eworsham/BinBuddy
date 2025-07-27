//
//  ContentView.swift
//  BinBuddy
//
//  Created by Ryan Worsham on 7/23/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var containers: [Container]
    @State private var isShowingContainerAlert = false
    @State private var newContainerName = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(containers) { container in
                    NavigationLink {
                        ContainerDetailView(container: container)
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(container.name)
                                .font(.headline)
                            Text("Created at \(container.createdAt.formatted())")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: deleteContainers)
            }
            .navigationTitle("Containers")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button("Add Container") {
                        promptForContainerName()
                    }
                }
            }
            .alert("New Container", isPresented: $isShowingContainerAlert, actions: {
                TextField("Container Name", text: $newContainerName)
                Button("Add Container", action: {
                    addContainer(name: newContainerName)
                    newContainerName = ""
                })
                Button("Cancel", role: .cancel, action: {
                    newContainerName = ""
                })
            })
        }
    }
    
    private func promptForContainerName() {
        isShowingContainerAlert = true
    }

    private func addContainer(name: String) {
        withAnimation {
            let newContainer = Container(name: name)
            modelContext.insert(newContainer)
        }
    }

    private func deleteContainers(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(containers[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Container.self, inMemory: true)
}
