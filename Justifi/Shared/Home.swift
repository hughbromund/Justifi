//
//  Home.swift
//  Justifi
//
//  Created by Hugh Bromund on 1/22/21.
//

import SwiftUI
import AVKit

//player = AVQueuePlayer()
//playerLayer = AVPlayerLayer(player: player)
//playerItem = AVPlayerItem(url: videoURL)
//playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
//player.play()


class PlayerUIView: UIView {
    private var playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    init(player: AVQueuePlayer, url: String) {
        super.init(frame: .zero)
        // let player2 = AVQueuePlayer()
        playerLayer = AVPlayerLayer(player: player)
        let playerItem = AVPlayerItem(url: URL(string: url)!)
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        player.play()
        // playerLayer.player = player
        layer.addSublayer(playerLayer)
        // print("Here")
        
    }
   required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
   }
    override func layoutSubviews() {
    super.layoutSubviews()
        playerLayer.frame = bounds
  }}

struct Home: View {
    
    var body: some View {
        ZStack{
            PlayerContainerView(player: AVQueuePlayer(), url: "https://videodelivery.net/763125bad164e2c7162aa877d1f0b3f8/manifest/video.m3u8")
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
        PlayerControlsView(player: player)
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

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
