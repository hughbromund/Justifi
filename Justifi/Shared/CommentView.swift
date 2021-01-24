//
//  CommentView.swift
//  Justifi
//
//  Created by Hugh Bromund on 1/24/21.
//

import SwiftUI
import SwiftUIPager
import Alamofire
import Request
import Json

struct CommentView: View {
    
    var videoInfo : VideoInfo
    
    @Binding var curIndex : Int
    
    @State private var curRowIndex : Int = 0
    
    @State private var commentVideos : [VideoInfo] = [VideoInfo]()
    
    @Binding var accessToken: String
    
    @StateObject private var page: Page = .first()
    
    @State private var firstLoad : Bool = true
    
    @State private var didLoadComments : Bool = false
    
//    @State private var data = Array(0..<4)
    
    var body: some View {
        ZStack {
            Pager(page: page,
                  data: commentVideos,
                  id: \.self,
                  content: { index in
                      // create a page based on the data passed
//                    HStack {
//                        Text("HEllo There")
//                    }
                    ZStack {
                        VideoView(index: videoInfo.index, rowIndex: index.index, videoURL: index.url, thumbnailURL: index.thumbnail, currentIndex: index.currentIndex, curRowIndex: $curRowIndex)
                    }
                    
                    .cornerRadius(5)
                    .shadow(radius: 5)
                  })
//                .loopPages()
                .onPageChanged({ page in
                    if (page >= commentVideos.count - 2) {
                        // Add More pages
                        print("Adding more pages...")
                    }
                    curRowIndex = page
                    print("Page changed to: \(page)")})
                .contentLoadingPolicy(.lazy(recyclingRatio: 5))
                .swipeInteractionArea(.allAvailable)
                .pagingPriority(.simultaneous)
                .itemSpacing(10)
                .padding(30)
        }.onAppear(perform: {
            print("Loading Comment Videos")
            if (firstLoad) {
                commentVideos.append(videoInfo)
                firstLoad = true
            }
            
            if (!didLoadComments) {
                Request {
                    Url("https://justifi.uc.r.appspot.com/api/video/response/\(videoInfo.uid)")
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
                            
                            commentVideos.append(VideoInfo(thumbnail: thumbnail, uid: uid, title: title, url: url, upvotes: upvotes, username: username, index: count, currentIndex: $curIndex))
                            
                            count+=1
                        }
                        
                        print(commentVideos)
                        
                        didLoadComments = true
                        // print(videoInfos)
                        
                        
                    } catch {
                        print("Error")
                    }
                   

                }.onError{ error in
                    print(error)
                }.call()
                
                
                
            }

            
            print(commentVideos.count)
        })
    }
}

//struct CommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentView()
//    }
//}
