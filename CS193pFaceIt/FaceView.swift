//
//  FaceView.swift
//  CS193pFaceIt
//
//  Created by zzk on 2017/3/2.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {

    @IBInspectable
    var scale: CGFloat = 0.9 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var eyesOpen: Bool = false {
        didSet {
            setNeedsDisplay()
            leftEye.eyesOpen = eyesOpen
            rightEye.eyesOpen = eyesOpen
        }
    }

    
    /// 1.0 is full smile and -1.0 is full frown
    @IBInspectable
    var mouthCurvature: Double = 1.0 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var lineWidth: CGFloat = 5 {
        didSet {
            setNeedsDisplay()
            leftEye.lineWidth = lineWidth
            rightEye.lineWidth = lineWidth
        }
    }

    
    @IBInspectable
    var color: UIColor = UIColor.blue {
        didSet {
            setNeedsDisplay()
            leftEye.color = color
            rightEye.color = color
        }
    }
    
    private enum Eye {
        case left, right
    }
    
    var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    var skullRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer) {
        switch pinchRecognizer.state {
        case .changed, .ended:
            scale *= pinchRecognizer.scale
            pinchRecognizer.scale = 1
        default:
            break
        }
    }
    
    private lazy var leftEye: EyeView = self.createEye()
    private lazy var rightEye: EyeView = self.createEye()
    
    private func centerOfEye(_ eye: Eye) -> CGPoint {
        let eyeOffset = skullRadius / Ratios.eyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        eyeCenter.x += ((eye == .left) ? -1 : 1) * eyeOffset
        return eyeCenter
    }
    
    private func createEye() -> EyeView {
        let eye = EyeView()
        eye.isOpaque = false
        eye.color = color
        eye.lineWidth = lineWidth
        addSubview(eye)
        return eye
    }
    
    private func positionEye(_ eye: EyeView, center: CGPoint) {
        let size = skullRadius / Ratios.eyeRadius * 2
        eye.frame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: size, height: size))
        eye.center = center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        positionEye(leftEye, center: centerOfEye(.left))
        positionEye(rightEye, center: centerOfEye(.right))
    }
    
    
//    private func pathForEye(_ eye: Eye) -> UIBezierPath {
//        
//        func centerOfEye(_ eye: Eye) -> CGPoint {
//            let eyeOffset = skullRadius / Ratios.eyeOffset
//            var eyeCenter = skullCenter
//            eyeCenter.y -= eyeOffset
//            eyeCenter.x += ((eye == .left) ? -1 : 1) * eyeOffset
//            return eyeCenter
//        }
//        let eyeRadius = skullRadius / Ratios.eyeRadius
//        let eyeCenter = centerOfEye(eye)
//        var path: UIBezierPath
//        if eyesOpen {
//            path = UIBezierPath.init(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
//        } else {
//            path = UIBezierPath()
//            path.move(to: CGPoint.init(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
//            path.addLine(to: CGPoint.init(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
//        }
//        path.lineWidth = lineWidth
//        return path
//        
//    }
    
    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.mouthWidth
        let mouthHeight = skullRadius / Ratios.mouthHeight
        let mouthOffet = skullRadius / Ratios.mouthOffset
        
        let mouthRect = CGRect.init(x: skullCenter.x - mouthWidth / 2, y: skullCenter.y + mouthOffet, width: mouthWidth, height: mouthHeight)
        
        let start = CGPoint.init(x: mouthRect.minX, y: mouthRect.midY)
        let end = CGPoint.init(x: mouthRect.maxX, y: mouthRect.midY)
        
        let smileOffset = CGFloat(max(min(1, mouthCurvature), -1)) * mouthRect.height
        
        let cp1 = CGPoint.init(x: start.x + mouthRect.width / 3, y: start.y + smileOffset)
        
        let cp2 = CGPoint.init(x: end.x - mouthRect.width / 3, y: start.y + smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    private func pathForSkull() -> UIBezierPath {
        let path = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false)
        path.lineWidth = lineWidth
        return path
    }
    
    
    override func draw(_ rect: CGRect) {
        color.set()
        pathForSkull().stroke()
//        pathForEye(.left).stroke()
//        pathForEye(.right).stroke()
        pathForMouth().stroke()
    }
    
    
    private struct Ratios {
        static let eyeOffset: CGFloat = 3
        static let eyeRadius: CGFloat = 10
        static let mouthWidth: CGFloat = 1
        static let mouthHeight: CGFloat = 3
        static let mouthOffset: CGFloat = 3
    }

}
