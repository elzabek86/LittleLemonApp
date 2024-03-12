//
//  Home.swift
//  LittleLemonApp
//
//  Created by Jarek  on 31/01/2024.
//

import SwiftUI

struct Home: View {
    
    var body: some View {
        MainScreen()
            .navigationBarBackButtonHidden()
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
