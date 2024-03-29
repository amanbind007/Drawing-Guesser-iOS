//
//  ContentView.swift
//  Drawing Guesser
//
//  Created by Aman Bind on 28/11/23.
//

import AlertToast
import SwiftUI

struct Line: Equatable {
    var points = [CGPoint]()
    var color: Color = .black
    var width: Double = 7
}

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewViewModel()
    @Environment(\.colorScheme) var theme

    @State var showAlert: Bool = false

    @State var buttonTitle: String = "Skip"

    var canvas: some View {
        return Canvas { context, _ in

            for line in viewModel.lines {
                var path = Path()
                path.addLines(line.points)
                context.stroke(path, with: .color(line.color), lineWidth: line.width)

                context.stroke(path, with: theme == .dark ? .color(.white) : .color(.black), style: StrokeStyle(lineWidth: line.width, lineCap: .round, lineJoin: .round))
            }
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { value in
                let newPoint = value.location

                viewModel.currentLine.points.append(newPoint)
                viewModel.lines.append(viewModel.currentLine)
            }
            .onEnded { _ in
                viewModel.lines.append(viewModel.currentLine)
                viewModel.currentLine = Line()
            }
        )
    }

    var body: some View {
        VStack {
            Text("Current Challenge: \(viewModel.currentChallenge)")
                .font(.largeTitle)
            if viewModel.lines.isEmpty {
                Text("Waiting for Drawing....")
                    .font(.title)
            }
            else if viewModel.guessedOutput == viewModel.currentChallenge {
                Text("It is \(viewModel.currentChallenge)")
                    .font(.title)
                    .onAppear {
                        buttonTitle = "Next"
                    }
            }
            else {
                if let guess = viewModel.guessedOutput {
                    Text("\(guess) 🤔")
                        .font(.title)
                }
                else {
                    Text("🤔")
                        .font(.title)
                }
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
                    showAlert = true
                    let image = Image(size: CGSize(width: UIScreen.main.bounds.width-5, height: UIScreen.main.bounds.width-5)) { context in
                        for line in viewModel.lines {
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
                .foregroundStyle(Color.white)
                .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .background {
                    RoundedRectangle(cornerRadius: 25)
                        .frame(height: 50)
                        .foregroundStyle(Color.green)
                }

                Spacer()

                Button("Clear Canvas") {
                    viewModel.lines = [Line]()
                }
                .foregroundStyle(Color.white)
                .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .background {
                    RoundedRectangle(cornerRadius: 25)
                        .frame(height: 50)
                        .foregroundStyle(Color.red)
                }

                Spacer()
            }
            .padding(.vertical, 10)
            Button(buttonTitle) {
                buttonTitle = "Skip"
                viewModel.getNewChallenge()
                viewModel.lines = [Line]()
            }
            .foregroundStyle(Color.white)
            .padding(.vertical, 20)
            .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            .background {
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 100, height: 50)
                    .foregroundStyle(Color.blue)
            }
        }
        .toast(isPresenting: $showAlert, alert: {
            AlertToast(displayMode: .hud, type: .regular, title: "Image saved in Photos Album")
        })
        .onChange(of: viewModel.lines) {
            let image = Image(size: CGSize(width: UIScreen.main.bounds.width-5, height: UIScreen.main.bounds.width-5)) { context in
                for line in viewModel.lines {
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
