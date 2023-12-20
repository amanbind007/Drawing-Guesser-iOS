//
//  ContentView.swift
//  Drawing Guesser
//
//  Created by Aman Bind on 28/11/23.
//

import SwiftUI

struct Line: Equatable {
    var points = [CGPoint]()
    var color: Color = .black
    var width: Double = 10
}



struct HomeView: View {
    @State private var currentLine = Line()
    @State private var lines = [Line]()
    
    @ObservedObject var viewModel = HomeViewViewModel()

    var canvas: some View {
        return Canvas { context, _ in

            for line in lines {
                var path = Path()
                path.addLines(line.points)
                context.stroke(path, with: .color(line.color), lineWidth: line.width)

                context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: line.width, lineCap: .round, lineJoin: .round))
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
            Text(viewModel.guessedOutput ?? "Hmm....")

            if lines.isEmpty {
                Text("Waiting for Drawing....")
            }
            else {
                Text("🤔 Guessing")
            }

            VStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(lineWidth: 3)
                    .frame(width: UIScreen.main.bounds.width-5, height: UIScreen.main.bounds.width-5)
                    .background {
                        canvas
                            .padding()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                    }
            }
            .padding(5)

            HStack {
                Spacer()
                Button("Save to image: Canvas") {
                    let image = Image(size: CGSize(width: UIScreen.main.bounds.width-5, height: UIScreen.main.bounds.width-5)) { context in
                        for line in lines {
                            var path = Path()
                            path.addLines(line.points)
                            context.stroke(path, with: .color(line.color), lineWidth: line.width)

                            context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: line.width, lineCap: .round, lineJoin: .round))
                        }
                    }
                    let renderer = ImageRenderer(content: image)
                    if let image = renderer.uiImage {
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    }
                }

                Spacer()

                Button("Clear Canvas") {
                    lines = [Line]()
                }

                Spacer()
            }
            
        }
        .onChange(of: lines) {
            let image = Image(size: CGSize(width: UIScreen.main.bounds.width-5, height: UIScreen.main.bounds.width-5)) { context in
                for line in lines {
                    var path = Path()
                    path.addLines(line.points)
                    context.stroke(path, with: .color(line.color), lineWidth: line.width)

                    context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: line.width, lineCap: .round, lineJoin: .round))
                }
            }
            let renderer = ImageRenderer(content: image)
            viewModel.predictDrawing(image: renderer.uiImage!)
        }
    }
}

#Preview {
    HomeView()
}
