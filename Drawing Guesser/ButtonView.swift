//
//  Button.swift
//  Drawing Guesser
//
//  Created by Aman Bind on 30/12/23.
//

import SwiftUI

struct ButtonView: View {
    State var buttonText: String = ""

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(height: 20)
        }
    }
}

#Preview {
    ButtonView(buttonText: "Hello")
}
