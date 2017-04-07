//
//  BlinkingViewController.swift
//  CS193pFaceIt
//
//  Created by zzk on 2017/4/4.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class BlinkingViewController: FaceViewController {

    var blinking = false {
        didSet {
            blinkingIfNeeded()
        }
    }
    
    private struct BlinkRate {
        static let closedDuration: TimeInterval = 0.4
        static let openDuration: TimeInterval = 2.5
    }
    
    private var canBlink = false
    
    private var inABlink = false
    
    private func blinkingIfNeeded() {
        if blinking && canBlink && !inABlink {
            faceView.eyesOpen = false
            inABlink = true
            Timer.scheduledTimer(withTimeInterval: BlinkRate.closedDuration, repeats: false, block: { [weak self] (timer) in
                self?.faceView.eyesOpen = true
                Timer.scheduledTimer(withTimeInterval: BlinkRate.openDuration, repeats: false, block: { (timer) in
                    self?.inABlink = false
                    self?.blinkingIfNeeded()
                })
            })
        }
    }
    
    override func updateUI() {
        super.updateUI()
        blinking = expression.eyes == .squinting
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        canBlink = true
        blinkingIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        canBlink = false
    }
}
