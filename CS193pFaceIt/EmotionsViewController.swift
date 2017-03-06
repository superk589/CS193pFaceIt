//
//  EmotionsViewController.swift
//  CS193pFaceIt
//
//  Created by zzk on 2017/3/4.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class EmotionsViewController: VCLLoggingViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var destinationViewController = segue.destination
        if let navigationcController = destinationViewController as? UINavigationController {
            destinationViewController = navigationcController.visibleViewController ?? destinationViewController
        }
        
        if let faceViewController = destinationViewController as? FaceViewController,
            let identifier = segue.identifier,
            let expression = emotionalFaces[identifier] {
            faceViewController.expression = expression
            faceViewController.navigationItem.title = (sender as? UIButton)?.currentTitle
        }
    }
    
    private let emotionalFaces: [String: FacialExpression] = [
        "sad": FacialExpression(eyes: .closed, mouth: .frown),
        "happy": FacialExpression(eyes: .open, mouth: .smile),
        "worried": FacialExpression(eyes: .open, mouth: .smirk),
    ]
}
