//
//  ScrollView.swift
//  Justifi
//
//  Created by Hugh Bromund on 1/23/21.
//

import SwiftUI
import SwiftUIPager

struct ScrollView: View {
    
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
                        Rectangle()
                            .fill(Color.yellow)
                        videoViews[index]
                    }
                    .cornerRadius(5)
                    .shadow(radius: 5)
                  }).vertical()
                .loopPages()
                .onPageChanged({ page in
                                print("Page changed to: \(page)")})
                .contentLoadingPolicy(.eager)
        VStack {
            HStack {
                Text("Justifi").font(.largeTitle).bold().padding()
                Spacer()
            }
            Spacer()
        }
        }
    }
}

struct ScrollView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView()
    }
}
