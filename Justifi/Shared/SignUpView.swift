//
//  SignUpView.swift
//  Justifi
//
//  Created by Aditya Naik on 1/24/21.
//

import SwiftUI
import Request
import Json

//let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

struct SignUpView: View {
    
    @Binding var showSignUp : Bool
    
    @State var username: String = ""
    @State var password: String = ""
    
    @State var signUpSuccess : Bool = false
    @State var isLoading : Bool = false
    
    var body: some View {
    
        ZStack {
            Color(red: 247.0/255.0, green: 244.0/255.0, blue: 243.0/255.0, opacity: 1.0).edgesIgnoringSafeArea(.all)
            VStack {
                Text("Sign Up")
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
                Button(action: {
                        print("Button tapped")
                        isLoading = true
                        Request {
                            Url("https://justifi.uc.r.appspot.com/api/auth/signup")
                            Method(.post)
                            Header.ContentType(.json)
                            RequestBody([
                                "username": username,
                                "password": password
                            ])
                        }.onData { data in
                            do {
                                try print("onData: \(Json(data))")
                                signUpSuccess = true
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
                        showSignUp = false
                }) {
                    Text(isLoading ? "LOADING..." :  "SIGN UP")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(signUpSuccess ? Color.green : Color(red: 19 / 255, green: 41 / 255, blue: 61 / 255))
                        .cornerRadius(15.0)
                }
            }
        }
    }
}
