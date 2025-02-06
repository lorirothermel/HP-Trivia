//
//  ContentView.swift
//  HP Trivia
//
//  Created by Lori Rothermel on 1/21/25.
//

import SwiftUI
import AVKit


struct ContentView: View {
    @EnvironmentObject private var store: Store
    
    @State private var audioPlayer: AVAudioPlayer!
    @State private var scalePlayButton = false
    @State private var moveBackgroundImage = false
    @State private var animateViewsIn = false
    @State private var showInstructions = false
    @State private var showSettings = false
    @State private var playGame = false
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("hogwarts")
                    .resizable()
                    .frame(width: geo.size.width*3, height: geo.size.height)
                    .padding(.top, 3)
                    .offset(x: moveBackgroundImage ? geo.size.width / 1.1 : -geo.size.width / 1.1)
                    .onAppear {
                        withAnimation(.linear(duration: 60).repeatForever()) {
                            moveBackgroundImage.toggle()
                        }  // withAnimation
                    }  // .onAppear
                
                
                VStack {
                    VStack {
                        if animateViewsIn {
                            VStack {
                                Image(systemName: "bolt.fill")
                                    .font(.largeTitle)
                                    .imageScale(.large)
                                    .foregroundColor(.yellow)
                                
                                Text("HP")
                                    .font(.custom(Constants.hpFont, size: 70))
                                    .foregroundColor(.yellow)
                                
                                Text("Trivia")
                                    .font(.custom(Constants.hpFont, size: 60))
                                    .foregroundColor(.yellow)
                                    .padding(.bottom, -50)
                                
                            }  // VStack
                            .padding(.top, 70)
                            .transition(.move(edge: .top))
                        }  // if
                    }  // VStack
                    .animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
                               
                    Spacer()
                    
                    VStack {
                        if animateViewsIn {
                            
                            VStack {
                                Text("Recent Scores")
                                    .font(.title2)
                                
                                Text("33")
                                Text("27")
                                Text("15")
                                
                            }  // VStack
                            .font(.title3)
                            .padding(.horizontal)
                            .foregroundColor(.white)
                            .background(.black.opacity(0.7))
                            .cornerRadius(15)
                            .transition(.opacity)
                            
                        }  // if
                    }  // VStack
                    .animation(.linear(duration: 1).delay(4), value: animateViewsIn)
                            
                    Spacer()
                
                    HStack {
                        Spacer()
                    
                        VStack {
                            if animateViewsIn {
                                
                                Button {
                                    // Show Instructions Screen
                                    showInstructions.toggle()
                                } label: {
                                    Image(systemName: "info.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .shadow(radius: 5)
                                }  // Button - Show Instructions
                                .transition(.offset(x: -geo.size.width / 4))
                                .fullScreenCover(isPresented: $showInstructions) {
                                    Instructions()
                                }  // .fullScreenCover
                                
                            }  // if
                        }  // VStack
                        .animation(.easeOut(duration: 0.7).delay(2.7), value: animateViewsIn)
                        
                        Spacer()
                        
                        VStack {
                            if animateViewsIn {
                                
                                Button {
                                    playGame.toggle()
                                } label: {
                                    Text("Play")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .padding(.vertical, 7)
                                        .padding(.horizontal, 50)
                                        .background(.brown)
                                        .cornerRadius(7)
                                        .shadow(radius: 5)
                                }  // Button - Play
                                .scaleEffect(scalePlayButton ? 1.2 : 1.0)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
                                        scalePlayButton.toggle()
                                    }  // withAnimation
                                }  // .onAppear
                                .transition(.offset(y: geo.size.height / 3))
                                .fullScreenCover(isPresented: $playGame) {
                                    GamePlay()
                                }  // .fullScreenCover
                                
                            }  // if
                        }  // VStack
                        .animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
                        
                        Spacer()
                                                 
                        VStack {
                            if animateViewsIn {
                                
                                Button {
                                    showSettings.toggle()
                                } label: {
                                    Image(systemName: "gearshape.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .shadow(radius: 5)
                                }  // Button - Settings Screen
                                .transition(.offset(x: geo.size.width / 4))
                                .fullScreenCover(isPresented: $showSettings) {
                                    Settings()
                                        .environmentObject(store)
                                }  // .sheet
                                
                            }  // if
                        }  // VStack
                        .animation(.easeOut(duration: 0.7).delay(2.7), value: animateViewsIn)
                                
                        Spacer()
                        
                    } // HStack
                    .frame(width: geo.size.width)
                
                    Spacer()
                    
                }  // VStack
                
            }  // ZStack
            .frame(width: geo.size.width, height: geo.size.height)
            .padding(.top, 3)
                            
        }  // GeometryReader
        .ignoresSafeArea()
        .onAppear {
            animateViewsIn = true
//            playAudio()
        }  // .onAppear
        
    }  // some View
    
    
    private func playAudio() {
        let sound = Bundle.main.path(forResource: "magic-in-the-air", ofType: "mp3")

        audioPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        audioPlayer.numberOfLoops = -1
        audioPlayer.play()
        
    }  // playAudio
    
    
}  // ContentView

#Preview {
    ContentView()
        .environmentObject(Store())
}
