//
//  ComboView.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 15.02.24.
//

import SwiftUI

struct ComboView: View {
    let combo: Int

    @State private var displayedCombo: Int = 0

    private var comboColor: Color {
        switch combo {
            case ..<5: .orange
            case ..<10: .red
            default: .purple
        }
    }

    var body: some View {
        PhaseAnimator([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], trigger: combo, content: { phase in
            let scale: CGFloat = switch phase {
                case 1, 2: 2.0
                case 3, 4, 5, 6, 7, 8: 1.4
                default: 1.0
            }
            let rotation: Double = switch phase {
                case 3: -22
                case 4: 22
                case 5: -16
                case 6: 16
                case 7: -10
                case 8: 8
                default: 0
            }
            let xOffset: CGFloat = switch phase {
                case 3: -14
                case 4: 14
                case 5: -10
                case 6: 10
                case 7: -5
                case 8: 4
                default: 0
            }

            Text("\(displayedCombo) combo")
                .font(.caption.smallCaps())
                .foregroundStyle(comboColor.gradient)
                .contentTransition(.numericText(value: Double(displayedCombo)))
                .scaleEffect(scale, anchor: .top)
                .rotationEffect(.degrees(rotation), anchor: .top)
                .offset(x: xOffset, y: (phase == 1 || phase == 2) ? 6 : 0)
        }, animation: { phase in
            switch phase {
                case 1: .spring(response: 0.06, dampingFraction: 0.35)
                case 2: .linear(duration: 0.5)
                case 9: .spring(response: 0.25, dampingFraction: 0.55)
                default: .spring(response: 0.04, dampingFraction: 0.4)
            }
        })
        .onAppear {
            displayedCombo = combo
        }
        .task(id: combo) {
            try? await Task.sleep(for: .milliseconds(70))
            withAnimation(.easeInOut(duration: 0.35)) {
                displayedCombo = combo
            }
        }
    }
}

#Preview {
    @Previewable @State var combo = 2

    VStack(spacing: 40) {
        ComboView(combo: combo)

        Button("Increment") {
            combo += 1
        }
    }
}
