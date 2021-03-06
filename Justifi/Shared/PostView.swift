//
//  PostView.swift
//  Justifi
//
//  Created by Hugh Bromund on 1/23/21.
//

import Request
import Json
import SwiftUI
import AVKit
import Alamofire

struct PostView: View {
    
    @Binding var postURL : URL
    @Binding var postUsername : String
    @Binding var accessToken: String
    @Binding var showUpload : Bool
    
    @State var postTitle : String = ""
    @State var uploadURL : String = ""
    @State var uploadUID : String = ""
    
    @State var isUploading : Bool = false
    @State var isSuccess : Bool = false
    
    @Binding var commentUploadSheet : Bool
    var commentVideoUID : String
    
    var body: some View {
        ZStack {
            Color(red: 247.0/255.0, green: 244.0/255.0, blue: 243.0/255.0, opacity: 1.0).edgesIgnoringSafeArea(.all)
            VStack{
                HStack {
                    Text("New Post")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    Spacer()
                }
                Spacer()
    //            HStack {
    //                Text("Preview your recording")
    //                    .font(.title3)
    //                    .padding()
    //                Spacer()
    //            }
                HStack {
                    VideoPlayer(player: AVPlayer(url: postURL))
                        .padding()
                        .cornerRadius(5.0)
                        .shadow(radius: 5)
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: 150, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    VStack {
    //                    HStack {
    //                        Text("Give your post a title")
    //                            .font(.title3)
    //                            .padding()
    //                        Spacer()
    //                    }
                        TextField("Post Title", text: $postTitle)
                            .padding()
                        HStack {
                            Text("By: \(postUsername)")
                                .bold()
                                .padding()
                                .font(.subheadline)
                            Spacer()
                        }
                    }
                }.frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Spacer()
                Button(action: {
                    if (isSuccess) {
                        showUpload = false
                        commentUploadSheet = false
                        return
                    }
                    print("Uploading Post")
                    isUploading = true
                    Request {
                        Url("https://justifi.uc.r.appspot.com/api/video/uploadURL")
                        Method(.get)
                        Header.Any(key: "x-access-token", value: accessToken)
                        Header.ContentType(.json)
                    }.onData { data in
                        do {
                            try print("onData: \(Json(data).result.string)")
                            try print(Json(data).result.uploadURL)
                            uploadURL = try Json(data).result.uploadURL.string
                            uploadUID = try Json(data).result.uid.string
                            print("uploadURL: \(uploadURL)")
                            print("uploadUID: \(uploadUID)")
                            
                            
                            AF.upload(multipartFormData: { multipartFormData in
                                multipartFormData.append(postURL, withName: "file")
                            }, to: uploadURL, method: .post).response { result in
                                print(Json(result))
                                Request {
                                    Url("https://justifi.uc.r.appspot.com/api/video/uploadData")
                                    Method(.post)
                                    Header.Any(key: "x-access-token", value: accessToken)
                                    Header.ContentType(.json)
                                    RequestBody([
                                        "uid": uploadUID,
                                        "title": postTitle,
                                        "isOriginal": commentVideoUID == "NONE" ? true : false,
                                        "origUID": commentVideoUID
                                    ])
                                }.onData { data in
                                    print("Success")
                                }.onError{ error in
                                    print(error)
                                    isUploading = false
                                }.call()
                                isUploading = false
                                isSuccess = true
                            }
                        } catch {
                            isUploading = false
                            print("Error")
                        }
                        
                    }
                    .onError { error in
                        print("onError: \(error)")
                    }
                    .call()
                    
                        
                }) {
                    if (isSuccess) {
                        Text("SUCCESS!")
                            .font(.headline)
                            .foregroundColor(Color(red: 247.0/255.0, green: 244.0/255.0, blue: 243.0/255.0, opacity: 1.0))
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(Color.green)
                            .cornerRadius(15.0)
                    } else {
                        Text(isUploading ? "UPLOADING" : "SUBMIT")
                            .font(.headline)
                            .foregroundColor(Color(red: 247.0/255.0, green: 244.0/255.0, blue: 243.0/255.0, opacity: 1.0))
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(Color(red: 19 / 255, green: 41 / 255, blue: 61 / 255))
                            .cornerRadius(15.0)
                    }
                }
                Spacer()
            }
            
        }
    }
}


struct PostView_Previews: PreviewProvider {
    @State static var tempURL : URL = URL(string: "https://hughbromund.com")!
    @State static var tempUsername : String = "HughBromund"
    @State static var tempToken : String = "HughBromund"
    @State static var tempUp : Bool = false


    static var previews: some View {
        PostView(postURL: $tempURL, postUsername: $tempUsername, accessToken: $tempToken, showUpload: $tempUp, commentUploadSheet: $tempUp, commentVideoUID : "NONE")
    }
}
