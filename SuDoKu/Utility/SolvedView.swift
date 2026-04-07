//
//  SolvedView.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 15.02.24.
//

import SwiftUI
import Defaults

struct SolvedView: View {
    @Default(.difficulty) private var difficulty
    
    let playAgainCallback: () -> Void
    
    @State private var animate = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "medal.fill")
                .font(.system(size: 75))
                .foregroundStyle(.accent)
                .padding(.bottom, 40)
                .rotationEffect(.degrees(animate ? 0 : -35))
                .scaleEffect(animate ? 1 : 1.2)
            
            Group {
                Text("solved.congratulations")
                
                Text("solved.congratulations.text")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 20)
            .scaleEffect(animate ? 1 : 0)
            
            Spacer()
            
            Button {
                playAgainCallback()
            } label: {
                Label("solved.prompt", systemImage: "")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.accent.opacity(0.25))
                    .foregroundStyle(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding(20)
            }
        }
        .padding(.vertical)
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            withAnimation(.spring(duration: 0.5, bounce: 0.3, blendDuration: 0.2)) {
                animate = true
            }
            
            let key: Defaults.Key<Int>
            
            switch difficulty {
                case .easy:
                    key = .easySolved
                case .medium:
                    key = .mediumSolved
                case .hard:
                    key = .hardSolved
                case .extreme:
                    key = .extremeSolved
            }
            
            Defaults[key] += 1
        }
    }
}

#Preview {
    SolvedView() {
        print("Play again")
    }
}
