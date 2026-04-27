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
    
    let maxCombo: Int
    let playAgainCallback: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "trophy.fill")
                .font(.system(size: 75))
                .foregroundStyle(.accent)
                .padding(.bottom, 40)
                .symbolEffect(.bounce, options: .nonRepeating)
            
            Group {
                Text("solved.congratulations")
                
                Text("solved.congratulations.text")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                if maxCombo >= 2 {
                    Text("solved.maxCombo \(maxCombo)")
                        .foregroundStyle(.orange)
                        .padding(.top, 4)
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            Button("solved.prompt", systemImage: "plus") {
                playAgainCallback()
            }
            .buttonSizing(.flexible)
            .controlSize(.extraLarge)
            .buttonStyle(.glassProminent)
            .padding(.horizontal, 20)
        }
        .onAppear {
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
    SolvedView(maxCombo: 7) {
        print("Play again")
    }
}
