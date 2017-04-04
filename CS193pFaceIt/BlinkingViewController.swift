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
    
    private func blinkingIfNeeded() {
        if blinking {
            faceView.eyesOpen = false
            Timer.scheduledTimer(withTimeInterval: BlinkRate.closedDuration, repeats: false, block: { [weak self] (timer) in
                self?.faceView.eyesOpen = true
                Timer.scheduledTimer(withTimeInterval: BlinkRate.openDuration, repeats: false, block: { (timer) in
                    self?.blinkingIfNeeded()
                })
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        blinking = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        blinking = false
    }
}
