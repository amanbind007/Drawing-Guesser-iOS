//
//  HomeViewViewMOdel.swift
//  Drawing Guesser
//
//  Created by Aman Bind on 14/12/23.
//

import Foundation
import CoreGraphics


class HomeViewViewModel: ObservableObject {
    
    var currentChallenge : String = Label().classLabels.randomElement()!
    @Published var guessedOutput : String?
    let model = DrawnImageClassifier()
    
    func getNewChallenge(){
        currentChallenge = Label().classLabels.randomElement()!
    }
    
    func predictDrawing(image: CGImage){
        
        do {
            let modelInput = try DrawnImageClassifierInput(imageWith: image)
            let output = try model.prediction(input: modelInput)
            
            guessedOutput = output.category
        }
        catch{
            print(error)
        }
    }
    
    
    
    
    
    
}


