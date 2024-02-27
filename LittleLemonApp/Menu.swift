//
//  Menu.swift
//  LittleLemonApp
//
//  Created by Jarek  on 31/01/2024.
//

import SwiftUI
import CoreData

struct Menu: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isDataLoaded = false // Track if data is loaded
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            Text("Little Lemon")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            Text("Chicago")
                .font(.title)
                .foregroundColor(.gray)
            
            Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            
            List {
                TextField("Search menu", text: $searchText)
                FetchedObjects(predicate: buildPredicate(), sortDescriptors: buildSortDescriptors()) { (dishes: [Dish]) in
                    ForEach(dishes) { dish in
                        HStack {
                            if let imageUrlString = dish.image,
                               let imageUrl = URL(string: imageUrlString) {
                                AsyncImage(url: imageUrl) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit) // Zachowanie proporcji obrazu
                                            .frame(width: 100, height: 100)
                                            .padding(.trailing, 10)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit) // Zachowanie proporcji obrazu
                                            .frame(width: 50, height: 50)
                                            .padding(.trailing, 10)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text("\(dish.title ?? "") - \"$\(dish.price ?? "")\"")
                                    .font(.headline)
                                
                                Text(dish.category ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle()) // List style
            
        }
        .padding()
        .onAppear {
            if !isDataLoaded { // Fetch data only if not loaded before
                getMenuData()
            }
        }
    }
    
    func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            return NSPredicate(value: true)
        } else {
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        }
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor]  {
        return [NSSortDescriptor(key: "title",
                                ascending: true,
                                 selector: #selector(NSString.localizedStandardCompare))]
    }
        
    
    
    // Funkcja pobierająca dane z menu
    func getMenuData() {
        PersistenceController.shared.clear()
        
        let menuAddress = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        
        guard let menuURL = URL(string: menuAddress) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: menuURL)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching menu data: \(error)")
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    if let finalObject = try? decoder.decode(MenuList.self, from: data) {
                        // Check if dish already exists before adding
                        let existingDishes = try viewContext.fetch(Dish.fetchRequest()) as! [Dish]
                        for menuItem in finalObject.menu {
                            if !existingDishes.contains(where: { $0.title == menuItem.title }) {
                                let dish = Dish(context: viewContext)
                                dish.title = menuItem.title
                                dish.image = menuItem.image
                                dish.price = menuItem.price
                                dish.category = menuItem.category
                            }
                        }
                        try viewContext.save()
                        isDataLoaded = true // Update state to mark data as loaded
                    } else {
                        print("Error decoding menu data")
                    }
                } catch {
                    print("Error decoding menu data: \(error)")
                }
            }
        }
        task.resume()
    }
}

    

#Preview {
    Menu()
}
