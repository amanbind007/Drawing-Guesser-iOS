//
//  HomeViewViewMOdel.swift
//  Drawing Guesser
//
//  Created by Aman Bind on 14/12/23.
//

import CoreML
import Foundation
import UIKit

class HomeViewViewModel: ObservableObject {
    @Published var currentChallenge: String = Label().classLabels.randomElement()!
    @Published var currentLine = Line()
    @Published var lines = [Line]()
    @Published var guessedOutput: String?
    
    let model: Drawing_Classifier_1 = {
        do {
            let config = MLModelConfiguration()
            return try Drawing_Classifier_1(configuration: config)
        } catch {
            print(error)
            fatalError("Couldn't create Drawing Classifier")
        }
    }()
    
    func getNewChallenge() {
        currentChallenge = Label().classLabels.randomElement()!
    }
    
    func predictDrawing(image: UIImage) {
        guard let resizedImage = image.resizeTo(size: CGSize(width: 299, height: 299)),
              let buffer = resizedImage.toBuffer()
        else {
            return
        }
        
        let output = try? model.prediction(image: buffer)
        
        if let out = output {
            guessedOutput = out.target.capitalized
        }
    }
}
