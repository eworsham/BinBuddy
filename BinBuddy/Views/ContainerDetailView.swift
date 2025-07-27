//
//  ContainerDetailView.swift
//  BinBuddy
//
//  Created by Ryan Worsham on 7/27/25.
//
import SwiftUI

struct ContainerDetailView: View {
    @Bindable var container: Container
    @State private var isShowingItemAlert = false
    @State private var newItemName = ""
    
    // Container Detail View
    var body: some View {
        AppHeader(subtitle: "\(container.name) (\(container.items.count) items)")
        
        ZStack(alignment: .bottomTrailing) {
            List {
                if (container.items.isEmpty) {
                    Text("No Items Created")
                        .foregroundColor(.secondary)
                        .italic()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 40)
                } else {
                    ForEach(container.items) { item in
                        Text(item.name)
                    }
                    .onDelete(perform: deleteItem)
                }
            }
            FloatingAddButton(action: promptForItemName)
                .padding(.trailing, 30)
        }
        .alert("New Item", isPresented: $isShowingItemAlert, actions: {
            TextField("Item Name", text: $newItemName)
            Button("Add Item", action: {
                addItem(name: newItemName)
                newItemName = ""
            })
            Button("Cancel", role: .cancel, action: {
                newItemName = ""
            })
        })
    }
    
    // Function for displaying the prompt to grab the new item name
    private func promptForItemName() {
        isShowingItemAlert = true
    }
    
    // Function for adding a new item
    private func addItem(name: String) {
        withAnimation {
            let newItem = Item(name: name)
            container.items.append(newItem)
        }
    }
    
    // Function for deleting an item
    private func deleteItem(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                container.items.remove(at: index)
            }
        }
    }
}

// Preview for development and debugging
#Preview {
    let previewContainer = Container(name: "Sample Bin")
    previewContainer.items.append(Item(name: "Wrench"))
    previewContainer.items.append(Item(name: "Hammer"))

    return NavigationStack {
        ContainerDetailView(container: previewContainer)
    }
    .modelContainer(for: [Container.self, Item.self], inMemory: true)
}
