//
//  LoginView.swift
//  Justifi
//
//  Created by Aditya Naik on 1/22/21.
//

import SwiftUI
import Request
import Json

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

struct LoginView: View {
    
    @Binding var accessToken : String
    @Binding var parentUsername : String
    
    @State var username: String = ""
    @State var password: String = ""
    
    @State var loginSuccess : Bool = false
    @State var isLoading : Bool = false
    
    @State var showSignUp : Bool = false
    
    var body: some View {
        ZStack {
            Color(red: 247.0/255.0, green: 244.0/255.0, blue: 243.0/255.0, opacity: 1.0).edgesIgnoringSafeArea(.all)
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom, 20)
                    .foregroundColor(Color(red: 19 / 255, green: 41 / 255, blue: 61 / 255))
                TextField("Username", text: $username)
                    .padding()
                    .autocapitalization(.none)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .foregroundColor(Color(red: 19 / 255, green: 41 / 255, blue: 61 / 255))
                SecureField("Password", text: $password)
                    .padding()
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .foregroundColor(Color(red: 19 / 255, green: 41 / 255, blue: 61 / 255))
                Text("Sign Up").padding(.bottom, 20).onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                    showSignUp = true
                }).sheet(isPresented: $showSignUp, content: {
                    SignUpView(showSignUp: $showSignUp)
                }).foregroundColor(Color(red: 19 / 255, green: 41 / 255, blue: 61 / 255))
                Button(action: {
                        print("Button tapped")
                        isLoading = true
                        Request {
                            Url("https://justifi.uc.r.appspot.com/api/auth/login")
                            Method(.post)
                            Header.ContentType(.json)
                            RequestBody([
                                "username": username,
                                "password": password
                            ])
                        }.onData { data in
                            do {
                                try print("onData: \(Json(data).accessToken)")
                                try print(Json(data).accessToken.string)
                                accessToken = try! Json(data).accessToken.string
                                parentUsername = try! Json(data).username.string
                                loginSuccess = true
                                isLoading = false
                            } catch {
                                print("Error")
                            }
                            
                        }
                        .onError { error in
                            print("onError: \(error)")
                            isLoading = false
                        }
                        .call()
                }) {
                    Text(isLoading ? "LOADING..." :  "LOGIN")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(loginSuccess ? Color.green : Color(red: 19 / 255, green: 41 / 255, blue: 61 / 255))
                        .cornerRadius(15.0)
                }
            }
        }
    }
    
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        // LoginView(accessToken: nil, parentUsername: nil)
//    }
//}
