//
//  SetupView.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 17.02.24.
//

import SwiftUI
import Defaults

struct SetupView: View {
    @Default(.setupComplete) var setupComplete
    
    @State private var setupSheetPresented = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Image("SuDoKu")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 100)
                .clipShape(.rect(cornerRadius: 16))
                .padding(.bottom, 20)
            
            Text("setup.name")
                .font(.largeTitle)
                .fontDesign(.serif)
            
            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            Button("setup.continue", systemImage: "chevron.forward.dotted.chevron.forward") {
                setupSheetPresented.toggle()
            }
            .buttonStyle(.glassProminent)
            .buttonSizing(.flexible)
            .controlSize(.extraLarge)
            .padding(.horizontal, 20)
        }
        .sheet(isPresented: $setupSheetPresented) {
            NavigationStack {
                Form {
                    FormControls()
                    
                    Button {
                        setupSheetPresented = false
                    } label: {
                        HStack {
                            Spacer()
                            Text("setup.continue")
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                .navigationTitle("setup.title")
                .navigationBarTitleDisplayMode(.inline)
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .onChange(of: setupSheetPresented) {
            if setupSheetPresented == false {
                setupComplete = true
            }
        }
    }
    
    struct FormControls: View {
        @Default(.allowMistakes) var allowMistakes
        @Default(.suggestionStrength) var suggestionStrength
        
        var body: some View {
            Section {
                Toggle("setup.mistakes", isOn: $allowMistakes)
            } footer: {
                Text("setup.mistakes.text")
            }
            
            Section {
                Picker("setup.suggestions", selection: $suggestionStrength) {
                    ForEach(Board.SuggestionStrength.allCases, id: \.hashValue) { strength in
                        Text(strength.name)
                            .tag(strength)
                    }
                }
            } footer: {
                Text("setup.suggestions.text")
            }
        }
    }
}

#Preview {
    SetupView()
}
