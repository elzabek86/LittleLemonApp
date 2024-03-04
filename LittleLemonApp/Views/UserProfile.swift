//
//  UserProfile.swift
//  LittleLemonApp
//
//  Created by Jarek  on 19/02/2024.
//

import SwiftUI

struct UserProfile: View {
    
    let firstName = UserDefaults.standard.string(forKey: kFirstName) ?? ""
    let lastName = UserDefaults.standard.string(forKey: kLastName) ?? ""
    let email = UserDefaults.standard.string(forKey: kEmail) ?? ""
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: Menu()) {
                    Text("Menu")
                }
                Text("Personal information")
                Image("Profile")
                Text(firstName)
                Text(lastName)
                Text(email)
                Button("Logout") {
                    
                    UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                    self.presentation.wrappedValue.dismiss()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    UserProfile()
}
