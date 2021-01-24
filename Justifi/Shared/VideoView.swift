//
//  VideoView.swift
//  Justifi
//
//  Created by Hugh Bromund on 1/23/21.
//

import SwiftUI
import AVKit
import URLImage
import Request
import Json

class PlayerUIView: UIView {
    private var playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    init(player: AVQueuePlayer, url: String) {
        super.init(frame: .zero)
        // let player2 = AVQueuePlayer()
        playerLayer = AVPlayerLayer(player: player)
        let playerItem = AVPlayerItem(url: URL(string: url)!)
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        player.pause()
        // playerLayer.player = player
        layer.addSublayer(playerLayer)
        // layer.frame = UIScreen.main.bounds
        // print("Here")
        
    }
   required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
   }
    override func layoutSubviews() {
    super.layoutSubviews()
        playerLayer.frame = bounds
  }}

struct VideoView: View {
    // var pageNum : Int
    
    var index : Int
    var rowIndex : Int
    
    var videoURL : String
    var thumbnailURL : String
    var videoTitle : String
    var videoUsername : String
    var videoUID : String
    
    @Binding var accessToken : String
    
    @State private var isLiked = false
    
    // @Binding var videoURL : URL
    @State private var isPaused = false
    @State private var  player: AVQueuePlayer = AVQueuePlayer()
    
    @State private var firstLoad : Bool = true
    
    @Binding var currentIndex : Int
    @Binding var curRowIndex : Int
    
//    static func == (lhs: VideoView, rhs: VideoView) -> Bool {
//        return ((lhs.pageNum - rhs.pageNum) != 0)
//    }
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(pageNum)
//        // hasher.combine(command)
//    }
    var body: some View {
        
        ZStack {
            if (currentIndex == index && curRowIndex == rowIndex) {
                ZStack {
                    URLImage(url: URL(string: thumbnailURL)!,
                             content: { image in
                                 image
                                     .resizable()
                                     .aspectRatio(contentMode: .fit)
                             })
                    PlayerContainerView(player: player, url: videoURL).onTapGesture {
                            print("Tapping Video // Video is \(isPaused)")
                            if (isPaused) {
                                player.play()
                                isPaused = false
                            } else {
                                player.pause()
                                isPaused = true
                            }
                        }
                    if (isPaused) {
                        Image(systemName: "play.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .font(Font.system(.largeTitle).bold())
                    }
                    
                }.onAppear {
                    if (firstLoad) {
                        firstLoad = false
                        Request {
                            Url("https://justifi.uc.r.appspot.com/api/video/hasLiked/\(videoUID)")
                            Method(.get)
                            Header.Any(key: "x-access-token", value: accessToken)
                            Header.ContentType(.json)
                        }.onData { data in
                            do{
                                try print(Json(data))
                                isLiked = try Json(data).hasLiked.bool
                            } catch {
                                print("error occured")
                            }
                        }.onError{ error in
                            print(error)
                        }.call()
                    }
                    print("Page appeared")
                    player.pause()
                    if (!isPaused) {
                        player.play()
                    }
                   
                }.onDisappear {
                    player.pause()
                }
                
            } else {
                URLImage(url: URL(string: thumbnailURL)!,
                         content: { image in
                             image
                                 .resizable()
                                 .aspectRatio(contentMode: .fit)
                         })
            }
            VStack {
                Spacer()
                Spacer()
//                Image(systemName: isLiked ? "heart.fill" : "heart")
////                    .resizable()
////                    .scaledToFit()
//                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
//                    .scaleEffect(likeAnimation ? 10 : 0)
//                    .opacity(likeAnimation ? 1 : 0)
//                    .animation(.spring())
//                    .foregroundColor(isLiked ? .red : .black)
                Spacer()
                Spacer()
                Spacer()
                HStack {
                    Text(videoTitle)
                        .font(.title)
                        .foregroundColor(.white)
                        .bold()
                        .padding(.bottom, 0)
                        .padding(.leading, 15)
                        
                    Spacer()
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.title)
                        .padding()
                        .foregroundColor(.red)
                        .onTapGesture {
                            print("Like Button Clicked")
                           
                            if (!isLiked) {
                                print("Liking Video")
                                Request {
                                    Url("https://justifi.uc.r.appspot.com/api/video/likeVideo/")
                                    Method(.post)
                                    Header.Any(key: "x-access-token", value: accessToken)
                                    Header.ContentType(.json)
                                    RequestBody(["uid": videoUID])
                                }.onData { data in
                                   print(data)
                                }.onError{ error in
                                    print(error)
                                }.call()
                            } else {
                                print("Removing Like")
                                Request {
                                    Url("https://justifi.uc.r.appspot.com/api/video/unlikeVideo/")
                                    Method(.post)
                                    Header.Any(key: "x-access-token", value: accessToken)
                                    Header.ContentType(.json)
                                    RequestBody(["uid": videoUID])
                                }.onData { data in
                                   print(data)
                                }.onError{ error in
                                    print(error)
                                }.call()
                            }
                            isLiked.toggle()
                        }
                }
                HStack {
                    Text(videoUsername)
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.top, 5)
                        .padding(.leading, 15)
                        .padding(.bottom, 10)
                    Spacer()
                    Image(systemName: "plus.bubble")
                        .font(.title2)
                        .padding()
                        .foregroundColor(.white)
                }
                Spacer()
            }

        }
    }
}

struct PlayerContainerView : View {
  private let player: AVQueuePlayer
  private let url: String
  init(player: AVQueuePlayer, url: String) {
    self.player = player
    self.url = url
  }
  var body: some View {
    VStack {
        PlayerView(player: player, url: url)
        // PlayerControlsView(player: player)
    }
  }
}
struct PlayerControlsView : View {
  let player: AVQueuePlayer
  var body: some View {
    Text("TODO")
  }
}


struct PlayerView: UIViewRepresentable {
    let player: AVQueuePlayer
    let url: String
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {  }
    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(player: player, url: url)
    }
}

//struct VideoView_Previews: PreviewProvider {
//    @State static var tempRow : Int = 1
//    @State static var tempCol : Int = 1
//
//
//    static var previews: some View {
//        VideoView(index: 0, rowIndex: 0, videoURL: DEFAULT_VIDEO_URL, thumbnailURL: DEFAULT_THUMBNAIL_URL, videoTitle: "A Critique of the Heizenburg Approach", videoUsername: "Albert", currentIndex: $tempCol, curRowIndex: $tempRow)
//    }
//}

// VideoView(index: videoInfo.index, rowIndex: index.index, videoURL: index.url, thumbnailURL: index.thumbnail, currentIndex: $curIndex, curRowIndex: $curRowIndex)
