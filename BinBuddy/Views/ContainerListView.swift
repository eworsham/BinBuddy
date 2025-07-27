//
//  ContainerListView.swift
//  BinBuddy
//
//  Created by Ryan Worsham on 7/23/25.
//

import SwiftUI
import SwiftData

struct ContainerListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var containers: [Container]
    @State private var isShowingContainerAlert = false
    @State private var newContainerName = ""

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
                        .onDelete(perform: deleteContainers)
                    }
                }
                FloatingAddButton(action: promptForContainerName)
                    .padding(.trailing, 30)
            }
            .background(Color(.systemGroupedBackground))
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
    let previewModelContainer = try! ModelContainer(for: Container.self, Item.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let sampleContainer1 = Container(name: "Garage Tools")
    sampleContainer1.items.append(Item(name: "Hammer"))
    sampleContainer1.items.append(Item(name: "Screwdriver"))
    
    let sampleContainer2 = Container(name: "Home Improvement")
    sampleContainer2.items.append(Item(name: "Level"))
    sampleContainer2.items.append(Item(name: "Measuring tape"))
    
    previewModelContainer.mainContext.insert(sampleContainer1)
    previewModelContainer.mainContext.insert(sampleContainer2)

    return ContainerListView()
        .modelContainer(previewModelContainer)
}
