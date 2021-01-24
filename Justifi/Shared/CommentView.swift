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
    
    @State var curIndex : Int
    
    @State private var commentVideos : [VideoInfo] = [VideoInfo]()
    
    @Binding var accessToken: String
    
    @StateObject private var page: Page = .first()
    
    @State private var firstLoad : Bool = true
    
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
                        VideoView(index: index.index, videoURL: index.url, thumbnailURL: index.thumbnail, currentIndex: index.currentIndex)
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
                    curIndex = page
                    print("Page changed to: \(page)")})
                .contentLoadingPolicy(.lazy(recyclingRatio: 5))
                .swipeInteractionArea(.allAvailable)
                .itemSpacing(10)
                .padding(8)
        }.onAppear(perform: {
            print("Loading Comment Videos")
            if (firstLoad) {
                commentVideos.append(videoInfo)
                firstLoad = true
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
