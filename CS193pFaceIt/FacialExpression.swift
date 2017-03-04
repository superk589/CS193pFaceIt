//
//  FacialExpression.swift
//  CS193pFaceIt
//
//  Created by zzk on 2017/3/3.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation

struct FacialExpression
{
    enum Eyes: Int {
        case open
        case closed
        case squinting
    }
    
    enum Mouth: Int {
        case frown
        case smirk
        case neutral
        case grin
        case smile
        
        var sadder: Mouth {
            return Mouth(rawValue: rawValue - 1) ?? .frown
        }
        var happier: Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .smile
        }
    }
    
    
    var sadder: FacialExpression {
        return FacialExpression.init(eyes: self.eyes, mouth: self.mouth.sadder)
    }
    
    var happier: FacialExpression {
        return FacialExpression.init(eyes: self.eyes, mouth: self.mouth.happier)
    }
    
    var eyes: Eyes
    var mouth: Mouth
}
