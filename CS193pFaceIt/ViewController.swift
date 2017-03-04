//
//  ViewController.swift
//  CS193pFaceIt
//
//  Created by zzk on 2017/3/2.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var faceView: FaceView! {
        didSet {
            let handler = #selector(FaceView.changeScale(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer.init(target: faceView, action: handler)
            faceView.addGestureRecognizer(pinchRecognizer)
            let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(toggleEyes(byReactingTo:)))
            faceView.addGestureRecognizer(tapRecognizer)
            let swipeUpRecogniezr = UISwipeGestureRecognizer.init(target: self, action: #selector(increaseHappiness))
            swipeUpRecogniezr.direction = .down
            faceView.addGestureRecognizer(swipeUpRecogniezr)
            let swipeDownRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(decreaseHappiness))
            swipeDownRecognizer.direction = .up
            faceView.addGestureRecognizer(swipeDownRecognizer)
            updateUI()
        }
    }
    
    var expression = FacialExpression.init(eyes: .open, mouth: .grin) {
        didSet {
            updateUI()
        }
    }
    
    
    private func updateUI() {
        switch expression.eyes {
        case .open:
            faceView?.eyesOpen = true
        default:
            faceView?.eyesOpen = false
        }
        faceView?.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0
    }

    private let mouthCurvatures = [FacialExpression.Mouth.grin: 0.5,
                                   .frown: -1.0, .smile: 1.0]
    func toggleEyes(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            let eyes: FacialExpression.Eyes = (expression.eyes == .closed ? .open : .closed)
            expression = FacialExpression.init(eyes: eyes, mouth: expression.mouth)
        }
    }
    
    func increaseHappiness() {
        expression = expression.happier
    }
    
    func decreaseHappiness() {
        expression = expression.sadder
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

