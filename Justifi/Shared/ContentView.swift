//
//  ContentView.swift
//  Shared
//
//  Created by Hugh Bromund on 1/22/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var animate = false
    @State private var likeAnimation = false
    @State private var isLiked = false
    private let duration: Double = 0.3
    private var animationScale: CGFloat{
        isLiked ? 0.6 : 2.0
    }
    
    func performAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(700)) {
            likeAnimation = false
        }
    }
    
    var body: some View {
        VStack{
            ZStack(alignment: .center) {
                Text("Welcome to Justifi!")
                    .padding().onTapGesture(count: 2) {
                        likeAnimation = true
                        performAnimation()
                        self.isLiked.toggle()
                    }
                
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .resizable()
                    .scaledToFit()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                    .scaleEffect(likeAnimation ? 1 : 0)
                    .opacity(likeAnimation ? 1 : 0)
                    .animation(.spring())
                    .foregroundColor(isLiked ? .red : .black)
                
            }
            Button(action: {
                self.animate = true
                DispatchQueue.main.asyncAfter(deadline: .now() + self.duration, execute: {
                    self.animate = false
                    self.isLiked.toggle()
                })
            }) {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .imageScale(/*@START_MENU_TOKEN@*/.medium/*@END_MENU_TOKEN@*/)
                    .foregroundColor(isLiked ? .red : .black)
            }
            .padding()
            .scaleEffect(animate ? animationScale : 1)
            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/(duration: duration))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
