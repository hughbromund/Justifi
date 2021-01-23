//
//  NavigationView.swift
//  Justifi
//
//  Created by Hugh Bromund on 1/23/21.
//

import SwiftUI

struct NavigationView: View {
    
    var body: some View {
        TabView() {
            ScrollView().tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            Text("Upload Page").tabItem {
                Image(systemName: "plus.app.fill")
                Text("Upload")
            }
            LoginView().tabItem {
                Image(systemName: "person")
                Text("Account")
            }
        }
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView()
    }
}
