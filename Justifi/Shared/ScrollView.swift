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

var DEFAULT_VIDEO_URL = "https://videodelivery.net/5bbd1c8f7881bb36cbe9106ce260f272/manifest/video.m3u8"

var DEFAULT_THUMBNAIL_URL = "https://videodelivery.net/5bbd1c8f7881bb36cbe9106ce260f272/thumbnails/thumbnail.jpg"


struct VideoInfo : Hashable, Equatable {
    var thumbnail : String
    var uid : String
    var title : String
    var url : String
    var upvotes : Int
    var username : String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
}

struct ScrollView: View {
    
    @Binding var accessToken: String
    
    @StateObject var page: Page = .first()
    
    @State var videoInfos : [VideoInfo] = [VideoInfo]()
    
    var body: some View {
        ZStack {
            Pager(page: page,
                  data: videoInfos,
                  id: \.self,
                  content: { index in
                      // create a page based on the data passed
                    ZStack {
                        VideoView(videoURL: index.url, thumbnailURL: index.thumbnail)
                    }
                    .cornerRadius(5)
                    .shadow(radius: 5)
                  }).vertical()
//                .loopPages()
                .onPageChanged({ page in
                    if (page >= videoInfos.count - 2) {
                        // Add More pages
                        print("Adding more pages...")
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
                    // print("list of video")
                    do {
                        // try print(Json(data).list.array)
                        
                        let tempList = try Json(data).list.array
                        
                        // print(tempList)
                        
                        
                        for item in tempList {
                            print(Json(item))
                            let thumbnail : String = Json(item).thumbnail.string
                            let uid : String = Json(item).uid.string
                            let title : String = Json(item).title.string
                            let url : String = Json(item).url.string
                            let upvotes : Int = Json(item).upvotes.int
                            let username : String = Json(item).username.string
                            
                            videoInfos.append(VideoInfo(thumbnail: thumbnail, uid: uid, title: title, url: url, upvotes: upvotes, username: username))
                        }
                        
                        // print(videoInfos)
                        
                        
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
