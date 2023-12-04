//
//  ContentView.swift
//  Drawing Guesser
//
//  Created by Aman Bind on 28/11/23.
//

import SwiftUI

struct Line {
    var points = [CGPoint]()
    var color: Color = .red
    var width: Double = 10
}

struct ContentView: View {
    @State private var currentLine = Line()
    @State private var lines = [Line]()

    var canvas: some View {
        Canvas { context, _ in

            for line in lines {
                var path = Path()
                path.addLines(line.points)
                context.stroke(path, with: .color(line.color), lineWidth: line.width)
            }
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { value in
                let newPoint = value.location
                currentLine.points.append(newPoint)
                self.lines.append(currentLine)
            }
            .onEnded { _ in
                self.lines.append(currentLine)
                self.currentLine = Line()
            }
        )
    }

    var body: some View {
        VStack {
            canvas
        }

        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)

        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(lineWidth: 3)
                .padding(3)
        }
        Button("Save to image: Canvas") {
            if let view = canvas as? Canvas<EmptyView> {
                let image = view.frame(width: 400, height: 400).snapshot()
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
    }
}

#Preview {
    ContentView()
}
