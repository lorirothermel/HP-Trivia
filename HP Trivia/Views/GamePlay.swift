//
//  GamePlay.swift
//  HP Trivia
//
//  Created by Lori Rothermel on 1/22/25.
//

import SwiftUI
import AVKit


struct GamePlay: View {
    @Environment(\.dismiss) private var dismiss
    
    @Namespace private var namespace
        
    @State private var animateViewsIn = false
    @State private var tappedCorrectAnswer = false
    @State private var hintWiggle = false
    @State private var scaleNextButton = false
    @State private var movePointsToScore = false
    @State private var revealHint = false
    @State private var revealBook = false
    @State private var wrongAnswersTapped: [Int] = []
    @State private var musicPlayer: AVAudioPlayer!
    @State private var sfxPlayer: AVAudioPlayer!
    
    
    
    let tempAnswers = [true, false, false, false]
    
    
    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                Image("hogwarts")
                    .resizable()
                    .frame(width: geo.size.width * 3, height: geo.size.height * 1.05)
                    .overlay(Rectangle().foregroundColor(.black.opacity(0.8)))
                
                VStack {
                    // MARK: Controls
                    HStack {
                        Button("End Game") {
                            // TODO: End Game
                            dismiss()
                        }  // Button - End Game
                        .buttonStyle(.borderedProminent)
                        .tint(.red.opacity(0.5))
                        
                        Spacer()
                        
                        Text("Score: 33")
                                                    
                    }  // HStack
                    .padding()
                    .padding(.vertical, 30)
                    
                    // MARK: Question
                    VStack {
                        if animateViewsIn {
                            Text("Who is Harry Potter?")
                                .font(.custom(Constants.hpFont, size: 50))
                                .multilineTextAlignment(.center)
                                .padding()
                                .transition(.scale)
                                .opacity(tappedCorrectAnswer ? 0.1 : 1)
                        }  // if
                    }  // VStack
                    .animation(.easeIn(duration: animateViewsIn ? 2 : 0), value: animateViewsIn)
                    
                    Spacer()
                    
                    // MARK: Hints
                    HStack {
                        VStack {
                            if animateViewsIn {
                                Image(systemName: "questionmark.app.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100)
                                    .foregroundColor(.cyan)
                                    .rotationEffect(.degrees(hintWiggle ? -13 : -17))
                                    .padding()
                                    .padding(.leading, 20)
                                    .transition(.offset(x: -geo.size.width / 2))
                                    .onAppear {
                                        withAnimation(.easeInOut(duration: 0.1)
                                                      .repeatCount(9)
                                                      .delay(5)
                                                      .repeatForever()) {
                                                          hintWiggle = true
                                        }  // withAnimation
                                    }  // .onAppear
                                    .onTapGesture {
                                        withAnimation(.easeOut(duration: 1.0)) {
                                            revealHint = true
                                        }  // withAnimation
                                        playFlipSound()
                                    }  // .onTapGesture
                                    .rotation3DEffect(.degrees(revealHint ? 1440 : 0), axis: (x: 0, y: 1, z: 0))
                                    .scaleEffect(revealHint ? 5 : 1)
                                    .opacity(revealHint ? 0 : 1)
                                    .offset(x: revealHint ? geo.size.width / 2 : 0)
                                    .overlay(
                                        Text("The boy who ______")
                                            .padding(.leading, 33)
                                            .minimumScaleFactor(0.5)
                                            .multilineTextAlignment(.center)
                                            .opacity(revealHint ? 1.0 : 0)
                                            .scaleEffect(revealHint ? 1.33 : 1.0)
                                    )  // .overlay
                                    .opacity(tappedCorrectAnswer ? 0.1 : 1)
                                    .disabled(tappedCorrectAnswer)
                            }  // if
                        }  // VStack
                        .animation(.easeOut(duration: animateViewsIn ? 1.5 : 0).delay(animateViewsIn ? 2 : 0), value: animateViewsIn)
                        
                        Spacer()
                        
                        VStack {
                            if animateViewsIn {
                                Image(systemName: "book.closed")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50)
                                    .foregroundColor(.black)
                                    .frame(width: 100, height: 100)
                                    .background(.cyan)
                                    .cornerRadius(20)
                                    .rotationEffect(.degrees(hintWiggle ? 13 : 17))
                                    .padding()
                                    .padding(.trailing, 20)
                                    .transition(.offset(x: geo.size.width / 2))
                                    .onAppear {
                                        withAnimation(.easeInOut(duration: 0.1)
                                                      .repeatCount(9)
                                                      .delay(5)
                                                      .repeatForever()) {
                                                          hintWiggle = true
                                        }  // withAnimation
                                    }  // .onAppear
                                    .onTapGesture {
                                        withAnimation(.easeOut(duration: 1.0)) {
                                            revealBook = true
                                        }  // withAnimation
                                        playFlipSound()
                                    }  // .onTapGesture
                                    .rotation3DEffect(.degrees(revealBook ? 1440 : 0), axis: (x: 0, y: 1, z: 0))
                                    .scaleEffect(revealBook ? 5 : 1)
                                    .opacity(revealBook ? 0 : 1)
                                    .offset(x: revealBook ? -geo.size.width / 2 : 0)
                                    .overlay(
                                        Image("hp1")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(.trailing, 33)
                                            .opacity(revealBook ? 1.0 : 0)
                                            .scaleEffect(revealBook ? 1.33 : 1.0)
                                    )  // .overlay
                                    .opacity(tappedCorrectAnswer ? 0.1 : 1)
                                    .disabled(tappedCorrectAnswer)
                            }  // if
                        }  // VStack
                        .animation(.easeOut(duration: animateViewsIn ? 1.5 : 0).delay(animateViewsIn ? 2 : 0), value: animateViewsIn)
                        
                    }  // HStack
                    .padding(.bottom)
                    
                    // MARK: Answers
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(1..<5) { i in
                            if tempAnswers[i-1] == true {
                                VStack {
                                    if animateViewsIn {
                                        if tappedCorrectAnswer == false {
                                            Text("Answer \(i)")
                                                .minimumScaleFactor(0.5)
                                                .multilineTextAlignment(.center)
                                                .padding(10)
                                                .frame(width: geo.size.width/2.15, height: 80)
                                                .background(.green.opacity(0.5))
                                                .cornerRadius(25)
                                                .transition(.asymmetric(insertion: .scale, removal: .scale(scale: 5).combined(with: .opacity.animation(.easeOut(duration: 0.5)))))
                                                .matchedGeometryEffect(id: "answer", in: namespace)
                                                .onTapGesture {
                                                    withAnimation(.easeOut(duration: 1)) {
                                                        tappedCorrectAnswer = true
                                                    }  // withAnimation
                                                    playCorrectSound()
                                                }  // .onTapGesture
                                        }  // if
                                    }  // if
                                }  // VStack
                                .animation(.easeOut(duration: animateViewsIn ? 1 : 0).delay(animateViewsIn ? 1.5 : 0), value: animateViewsIn)
                            } else {
                                VStack {
                                    if animateViewsIn {
                                        Text("Answer \(i)")
                                            .minimumScaleFactor(0.5)
                                            .multilineTextAlignment(.center)
                                            .padding(10)
                                            .frame(width: geo.size.width/2.15, height: 80)
                                            .background(wrongAnswersTapped.contains(i) ? .red.opacity(0.5) : .green.opacity(0.5))
                                            .cornerRadius(25)
                                            .transition(.scale)
                                            .onTapGesture {
                                                withAnimation(.easeOut(duration: 1)) {
                                                    wrongAnswersTapped.append(i)
                                                }  // withAnimation
                                                playWrongSound()
                                                giveWrongFeedback()
                                            }  // .onTapGesture
                                            .scaleEffect(wrongAnswersTapped.contains(i) ? 0.8 : 1)
                                            .disabled(tappedCorrectAnswer || wrongAnswersTapped.contains(i))
                                            .opacity(tappedCorrectAnswer ? 0.1 : 1)
                                    }  // if
                                }  // VStack
                                .animation(.easeOut(duration: animateViewsIn ? 1 : 0).delay(animateViewsIn ? 1.5 : 0), value: animateViewsIn)
                            }  // if..else
                        }  // ForEach
                    }  // LazyVGrid

                    
                    Spacer()
                    
                }  // VStack
                .frame(width: geo.size.width, height: geo.size.height)
                .foregroundColor(.white)
                
                // MARK: Celebration
                VStack {
                    
                    Spacer()
                    
                    VStack {
                        if tappedCorrectAnswer {
                            Text("5")
                                .font(.largeTitle)
                                .padding(.top, 50)
                                .transition(.offset(y: -geo.size.height / 4))
                                .offset(x: movePointsToScore ? geo.size.width / 2.3 : 0,
                                        y: movePointsToScore ? -geo.size.height / 13 : 0)
                                .opacity(movePointsToScore ? 0 : 1.0)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1.0).delay(3)) {
                                        movePointsToScore = true
                                    }  // withAnimation
                                }  // .onAppear
                        } // if
                    }  // VStack
                    .animation(.easeIn(duration: 1).delay(2), value: tappedCorrectAnswer)
                    
                    Spacer()
                    
                    VStack {
                        if tappedCorrectAnswer {
                            Text("Brilliant!")
                                .font(.custom(Constants.hpFont, size: 100))
                                .transition(.scale.combined(with: .offset(y: -geo.size.height / 2)))
                        }  // if
                    }  // VStack
                    .animation(.easeInOut(duration: tappedCorrectAnswer ? 1 : 0).delay(tappedCorrectAnswer ? 1 : 0), value: tappedCorrectAnswer)
                    
                    Spacer()
                    if tappedCorrectAnswer {
                        Text("Answer 1")
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                            .padding(10)
                            .frame(width: geo.size.width / 2.15, height: 80)
                            .background(.green.opacity(0.5))
                            .cornerRadius(24)
                            .scaleEffect(2)
                            .matchedGeometryEffect(id: "answer", in: namespace)
                    }  // if
                    
                    Group {
                        Spacer()
                        Spacer()
                    }  // Group
                    
                    VStack {
                        if tappedCorrectAnswer {
                            Button("Next Level >") {
                                animateViewsIn = false
                                tappedCorrectAnswer = false
                                revealHint = false
                                revealBook = false
                                movePointsToScore = false
                                wrongAnswersTapped = []
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    animateViewsIn = true
                                }  // DispatchQueue
                                
                            }  // Button - Next Level
                            .buttonStyle(.borderedProminent)
                            .tint(.blue.opacity(0.5))
                            .font(.largeTitle)
                            .transition(.offset(y: geo.size.height / 3))
                            .scaleEffect(scaleNextButton ? 1.2 : 1.0)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
                                    scaleNextButton.toggle()
                                }  // withAnimation
                            }  // .onAppear
                        }  // if
                    }  // VStack
                    .animation(.easeInOut(duration: tappedCorrectAnswer ? 2.7 : 0).delay(tappedCorrectAnswer ? 2.7 : 0), value: tappedCorrectAnswer)
                    
                    Group {
                        Spacer()
                        Spacer()
                    }  // Group
                    
                }  // VStack
                .foregroundColor(.white)
                
            }  // ZStack
            .frame(width: geo.size.width, height: geo.size.height)
            
            
        }  // GeometryReader
        .ignoresSafeArea()
        .onAppear {
            animateViewsIn = true
//            playMusic()
        }  // .onAppear
        
    }  // some View
  
    
    private func playMusic() {
        let songs = ["let-the-mystery-unfold", "spellcraft", "hiding-place-in-the-forest", "deep-in-the-dell"]
        let i = Int.random(in: 0...3)
        
        let sound = Bundle.main.path(forResource: songs[i], ofType: "mp3")

        musicPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        musicPlayer.volume = 0.1
        musicPlayer.numberOfLoops = -1
        musicPlayer.play()
        
    }  // playMusic
    
    private func playFlipSound() {
        let sound = Bundle.main.path(forResource: "page-flip", ofType: "mp3")
        
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.play()
    }  // playFlipSound
    
    
    private func playWrongSound() {
        let sound = Bundle.main.path(forResource: "negative-beeps", ofType: "mp3")
        
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.play()
    }  // playFlipSound
    
    private func playCorrectSound() {
        let sound = Bundle.main.path(forResource: "magic-wand", ofType: "mp3")
        
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.play()
    }  // playFlipSound
    
}  // GamePlay


private func giveWrongFeedback() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.error)
}  // giveWrongFeedback


#Preview {
    VStack {
        GamePlay()
    }
}
