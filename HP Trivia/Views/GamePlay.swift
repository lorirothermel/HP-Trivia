//
//  GamePlay.swift
//  HP Trivia
//
//  Created by Lori Rothermel on 1/22/25.
//

import SwiftUI

struct GamePlay: View {
    @Environment(\.dismiss) private var dismiss
        
    @State private var animateViewsIn = false
    @State private var tappedCorrectAnswer = false
    @State private var hintWiggle = false
    @State private var scaleNextButton = false
    @State private var movePointsToScore = false
    @State private var revealHint = false
    @State private var revealBook = false
    
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
                        }  // if
                    }  // VStack
                    .animation(.easeIn(duration: 2), value: animateViewsIn)
                    
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
                                
                            }  // if
                        }  // VStack
                        .animation(.easeOut(duration: 1.5).delay(2), value: animateViewsIn)
                        
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
                            }  // if
                        }  // VStack
                        .animation(.easeOut(duration: 1.5).delay(2), value: animateViewsIn)
                        
                    }  // HStack
                    .padding(.bottom)
                    
                    // MARK: Answers
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(1..<5) { i in
                            if animateViewsIn {
                                Text(i == 3 ? "The boy who basically lived and got sent to his relatives house where he was treated quite badly if I'm being honest but yeah." : "Answer \(i)")
                                    .minimumScaleFactor(0.5)
                                    .multilineTextAlignment(.center)
                                    .padding(10)
                                    .frame(width: geo.size.width/2.15, height: 80)
                                    .background(.green.opacity(0.5))
                                    .cornerRadius(25)
                                    .transition(.scale)
                            }  // if
                        }  // ForEach
                    }  // LazyVGrid
                    .animation(.easeOut(duration: 1).delay(1.5), value: animateViewsIn)
                    
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
                    .animation(.easeInOut(duration: 1).delay(1), value: tappedCorrectAnswer)
                    
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
                    }  // if
                    
                    Group {
                        Spacer()
                        Spacer()
                    }  // Group
                    
                    VStack {
                        if tappedCorrectAnswer {
                            Button("Next Level >") {
                                // TODO: Reset level for next question
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
                    .animation(.easeInOut(duration: 2.7).delay(2.7), value: tappedCorrectAnswer)
                    
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
//            tappedCorrectAnswer = true
        }  // .onAppear
        
    }  // some View
    
    
}  // GamePlay

#Preview {
    VStack {
        GamePlay()
    }
}
