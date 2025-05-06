//
//  ButtonStyle.swift
//  RockPaperScissors
//
//  Created by Christin Lacey on 5/3/25.
//

import SwiftUI

struct ButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.borderedProminent)
            .shadow(radius: 5)
    }
}

extension View {
    
    func choiceButtonStyle() -> some View {
        modifier(ButtonStyle())
    }
}
