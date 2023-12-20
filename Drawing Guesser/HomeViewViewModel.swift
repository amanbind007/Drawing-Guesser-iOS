//
//  HomeViewViewMOdel.swift
//  Drawing Guesser
//
//  Created by Aman Bind on 14/12/23.
//

import Foundation
import UIKit

class HomeViewViewModel: ObservableObject {
    
    var currentChallenge : String = Label().classLabels.randomElement()!
    @Published var guessedOutput : String?
    let model = Drawing_Classifier()
    
    func getNewChallenge(){
        currentChallenge = Label().classLabels.randomElement()!
    }
    
    func predictDrawing(image: UIImage){
        
        
        guard let resizedImage = image.resizeTo(size: CGSize(width: 299, height: 299)),
            let buffer = resizedImage.toBuffer()
        else {
            return
        }
        
        let output = try? model.prediction(image: buffer)
        
        if let output = output {
            self.guessedOutput = output.classLabel
        }
    }
    
    
    
    
    
    
}


