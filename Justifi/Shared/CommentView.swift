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
    
    @State var commentVideos : [VideoInfo] = [VideoInfo]()
    
    @Binding var accessToken: String
    
    @StateObject var page: Page = .first()
    
    var body: some View {
        ZStack {
            Pager(page: page,
                  data: commentVideos,
                  id: \.self,
                  content: { index in
                      // create a page based on the data passed
                    ZStack {
                        VideoView(index: index.index, videoURL: index.url, thumbnailURL: index.thumbnail, currentIndex: index.currentIndex)
                    }
                    .cornerRadius(5)
                    .shadow(radius: 5)
                  }).vertical()
//                .loopPages()
                .onPageChanged({ page in
                    if (page >= commentVideos.count - 2) {
                        // Add More pages
                        print("Adding more pages...")
                    }
                    curIndex = page
                    print("Page changed to: \(page)")})
                .contentLoadingPolicy(.lazy(recyclingRatio: 5))
        }.onAppear(perform: {
            print("Loading Comment Videos")
            
            
            
            
            
        })
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView()
    }
}
