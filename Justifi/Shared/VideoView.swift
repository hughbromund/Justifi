//
//  VideoView.swift
//  Justifi
//
//  Created by Hugh Bromund on 1/23/21.
//

import SwiftUI
import AVKit
import URLImage

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
    
    var videoURL : String
    var thumbnailURL : String
    
    
    // @Binding var videoURL : URL
    @State private var isPaused = false
    @State private var  player: AVQueuePlayer = AVQueuePlayer()
    
    @State private var firstLoad : Bool = true
    
    @Binding var currentIndex : Int
    
//    static func == (lhs: VideoView, rhs: VideoView) -> Bool {
//        return ((lhs.pageNum - rhs.pageNum) != 0)
//    }
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(pageNum)
//        // hasher.combine(command)
//    }
    var body: some View {
        
        
        if (currentIndex == index) {
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
                print("Page appeared")
                player.pause()
                if (!isPaused) {
                    player.play()
                }
               
            }.onDisappear {
                player.pause()
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
//
//struct VideoView_Previews: PreviewProvider {
//    static var previews: some View {
//        VideoView(videoURL: DEFAULT_VIDEO_URL, thumbnailURL: DEFAULT_THUMBNAIL_URL)
//    }
//}
