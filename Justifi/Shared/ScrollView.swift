//
//  ScrollView.swift
//  Justifi
//
//  Created by Hugh Bromund on 1/23/21.
//

import SwiftUI
import SwiftUIPager
import Alamofire
import Request
import Json

struct ScrollView: View {
    
    @Binding var accessToken: String
    
    @StateObject var page: Page = .first()
    
    
    // @ObservedObject var page: Page = .first()
    var items = Array(0..<3)
    
    var videoViews = Array([VideoView(pageNum: 0), VideoView(pageNum: 1), VideoView(pageNum: 2)])
    
    var body: some View {
        ZStack {
            Pager(page: page,
                  data: items,
                  id: \.self,
                  content: { index in
                      // create a page based on the data passed
                    ZStack {
                        videoViews[index]
                    }
                    .cornerRadius(5)
                    .shadow(radius: 5)
                  }).vertical()
                .loopPages()
                .onPageChanged({ page in
                    if (page == videoViews.count - 2) {
                        // Add More pages
                    }
                    print("Page changed to: \(page)")})
                .contentLoadingPolicy(.lazy(recyclingRatio: 5))
            VStack {
                HStack {
                    Text("Justifi").font(.largeTitle).bold().padding()
                    Spacer()
                }
                Spacer()
            }
        }.onAppear(perform: {
            print("Home Appeared")
            Request {
                Url("https://justifi.uc.r.appspot.com/api/video/updateFeed")
                Method(.post)
                Header.Any(key: "x-access-token", value: accessToken)
                Header.ContentType(.json)
            }.onData { data in
                print("Update Feed Success")
                Request {
                    Url("https://justifi.uc.r.appspot.com/api/video/list")
                    Method(.get)
                    Header.Any(key: "x-access-token", value: accessToken)
                    Header.ContentType(.json)
                }.onData { data in
                    print("list of video")
                    do {
                        try print(Json(data))
                    } catch {
                        print("Error")
                    }
                   

                }.onError{ error in
                    print(error)
                }.call()
            }.onError{ error in
                print(error)
            }.call()
        })
    }
}

struct ScrollView_Previews: PreviewProvider {
    @State static var tempToken : String = "HughBromund"
    
    static var previews: some View {
        ScrollView(accessToken: $tempToken)
    }
}
