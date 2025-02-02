//
//  Instructions.swift
//  HP Trivia
//
//  Created by Lori Rothermel on 1/22/25.
//

import SwiftUI

struct Instructions: View {
    @Environment(\.dismiss) private var dismiss
        
    
    var body: some View {
        ZStack {
            InfoBackgroundImage()
            
            VStack {
                Image("appiconwithradius")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .padding(.top)
                
                ScrollView {
                    Text("How to Play")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Welcome to HP Trivia! In this game, you will be asked random questions from the HP books and you must guess the right answer or you will lose points! 😱")
                            .padding([.horizontal, .bottom])

                                                    
                        Text("Each question is worth five (5) points, but if you guess a wrong answer, you will lose a (1) point.")
                            .padding([.horizontal, .bottom])

                        
                        Text("If you are struggling with a question, there is an option to reveal a hint or reveal the book that answers the question. But beware! Using these also minuses (1) one point each.")
                            .padding([.horizontal, .bottom])

                                                    
                        Text("When you select the correct answer, you will be rewarded all the points left for that question and they will be added to your total score.")
                            .padding(.horizontal)
                                                
                    }  // VStack
                    .font(.title3)

                }  // ScrollView
                .foregroundColor(.black)

                Button("Done") {
                    dismiss()
                }  // Button - Done
                .doneButton()

            }  // VStack
            
        }  // ZStack
                
    }  // some View
    
}  // Instructions


#Preview {
    Instructions()
}
