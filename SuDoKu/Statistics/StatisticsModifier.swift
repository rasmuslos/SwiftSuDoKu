//
//  StatisticsModifier.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 15.02.24.
//

import SwiftUI

struct StatisticsModifier: ViewModifier {
    @State private var statisticsSheetPresented = false
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        statisticsSheetPresented.toggle()
                    } label: {
                        Label("statistics", systemImage: "trophy.fill")
                            .labelStyle(.iconOnly)
                    }
                }
            }
            .sheet(isPresented: $statisticsSheetPresented) {
                StatisticsSheet()
            }
    }
}

#Preview {
    NavigationStack {
        Text(verbatim: ":)")
            .modifier(StatisticsModifier())
    }
}
