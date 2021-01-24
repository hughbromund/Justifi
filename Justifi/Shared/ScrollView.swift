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
    static func == (lhs: VideoInfo, rhs: VideoInfo) -> Bool {
        return rhs.uid == lhs.uid
    }
    
    var thumbnail : String
    var uid : String
    var title : String
    var url : String
    var upvotes : Int
    var username : String
    
    var index : Int
    
    var currentIndex : Binding<Int>
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
}

struct ScrollView: View {
    
    @Binding var accessToken: String
    @Binding var postUsername: String
    
    @StateObject var page: Page = .first()
    
    @State var videoInfos : [VideoInfo] = [VideoInfo]()
    
    @State var curIndex : Int = 0
    
    @State var didLoadVideos: Bool = false
    
    var body: some View {
        ZStack {
            Color(red: 247.0/255.0, green: 244.0/255.0, blue: 243.0/255.0, opacity: 1.0).edgesIgnoringSafeArea(.all)
            Pager(page: page,
                  data: videoInfos,
                  id: \.self,
                  content: { index in
                      // create a page based on the data passed
                    ZStack {
                        
                 
                        CommentView(videoInfo: index, curIndex: $curIndex, accessToken: $accessToken, postUsername: $postUsername)
                        // Rectangle()
                        
                        // VideoView(index: index.index, videoURL: index.url, thumbnailURL: index.thumbnail, currentIndex: index.currentIndex)
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
                    curIndex = page
                    print("Page changed to: \(page)")})
                .contentLoadingPolicy(.lazy(recyclingRatio: 5))
                .swipeInteractionArea(.allAvailable)
                .pagingPriority(.simultaneous)
            VStack {
                HStack {
//                    Text("Justifi").font(.largeTitle).bold().padding()
                    Image("splash_page_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50.0, height: 50.0)
                    Spacer()
                }
                Spacer()
            }
        }.onAppear(perform: {
            print("Home Appeared")
            
            
            if (!didLoadVideos) {
                
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
                            
                            var count : Int = 0
                            for item in tempList {
                                print(Json(item))
                                let thumbnail : String = Json(item).thumbnail.string
                                let uid : String = Json(item).uid.string
                                let title : String = Json(item).title.string
                                let url : String = Json(item).url.string
                                let upvotes : Int = Json(item).upvotes.int
                                let username : String = Json(item).username.string
                                
                                videoInfos.append(VideoInfo(thumbnail: thumbnail, uid: uid, title: title, url: url, upvotes: upvotes, username: username, index: count, currentIndex: $curIndex))
                                
                                count+=1
                            }
                            didLoadVideos = true
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
            }
        })
    }
}

struct ScrollView_Previews: PreviewProvider {
    @State static var tempToken : String = "HughBromund"
    
    
    static var previews: some View {
        ScrollView(accessToken: $tempToken, postUsername: $tempToken)
    }
}
