//
//  NavigationView.swift
//  Justifi
//
//  Created by Hugh Bromund on 1/23/21.
//

import SwiftUI

var DEFAULT_TOKEN = "NONE"

struct NavigationView: View {
    @State var accessToken: String = DEFAULT_TOKEN
    @State var username: String = DEFAULT_TOKEN
    
    @State var tempBool : Bool = false
    
    var body: some View {
        TabView() {
            ScrollView(accessToken: $accessToken, postUsername: $username).tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            RecorderView(postUsername: $username, accessToken: $accessToken, commentUploadSheet: $tempBool, commentVideoUID: "NONE").tabItem {
                Image(systemName: "plus.app.fill")
                Text("Upload")
            }
            if (accessToken == DEFAULT_TOKEN) {
                LoginView(accessToken: $accessToken, parentUsername: $username).tabItem {
                    Image(systemName: "person")
                    Text("Account")
                }
            } else {
                AccountView().tabItem {
                    Image(systemName: "person")
                    Text("Account")
                }
            }
        }.accentColor(Color(red: 19 / 255, green: 41 / 255, blue: 61 / 255))
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView()
    }
}
