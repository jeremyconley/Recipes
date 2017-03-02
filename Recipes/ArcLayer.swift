//
//  ArcLayer.swift
//  Recipes
//
//  Created by Jeremy Conley on 2/17/17.
//  Copyright © 2017 JeremyConley. All rights reserved.
//

import UIKit

class ArcLayer: CAShapeLayer {
    let animationDuration: CFTimeInterval = 0.25
    
    let x = UIScreen.main.bounds.width
    let y = UIScreen.main.bounds.height
    
    override init() {
        super.init()
        fillColor = UIColor.red.cgColor
        path = arcPathStarting.cgPath
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var arcPathPre: UIBezierPath {
        var arcPath = UIBezierPath()
        arcPath.move(to: CGPoint(x: 0.0, y: y)) //MaxHeight
        arcPath.addLine(to: CGPoint(x: 0.0, y: y - 10))
        arcPath.addLine(to: CGPoint(x: x, y: y - 10))
        arcPath.addLine(to: CGPoint(x: x, y: y))//MaxHeight
        arcPath.addLine(to: CGPoint(x: 0.0, y: y))//MaxHeight
        arcPath.close()
        return arcPath
    }
    
    var arcPathStarting: UIBezierPath {
        var arcPath = UIBezierPath()
        arcPath.move(to: CGPoint(x: 0.0, y: y))//MaxHeight
        arcPath.addLine(to: CGPoint(x: 0.0, y: y - 50))
        arcPath.addCurve(to: CGPoint(x: x, y: y - 50), controlPoint1: CGPoint(x: 100, y: y - 60), controlPoint2: CGPoint(x: 200.0, y: y - 30))
        arcPath.addLine(to: CGPoint(x: x, y: y))//MaxHeight
        arcPath.addLine(to: CGPoint(x: 0.0, y: y))//MaxHeight
        arcPath.close()
        return arcPath
    }
    
    var arcPathLow: UIBezierPath {
        var arcPath = UIBezierPath()
        arcPath.move(to: CGPoint(x: 0.0, y: y))//MaxHeight
        arcPath.addLine(to: CGPoint(x: 0.0, y: y - 100))
        arcPath.addCurve(to: CGPoint(x: x, y: y - 100), controlPoint1: CGPoint(x: 100, y: y - 110), controlPoint2: CGPoint(x: 200, y: y - 90))
        arcPath.addLine(to: CGPoint(x: x, y: y))//MaxHeight
        arcPath.addLine(to: CGPoint(x: 0.0, y: y))//MaxHeight
        arcPath.close()
        return arcPath
    }
    
    var arcPathMid: UIBezierPath {
        var arcPath = UIBezierPath()
        arcPath.move(to: CGPoint(x: 0.0, y: y))//MaxHeight
        arcPath.addLine(to: CGPoint(x: 0.0, y: y - 200))
        arcPath.addCurve(to: CGPoint(x: x, y: y - 200), controlPoint1: CGPoint(x: 100, y: y - 210), controlPoint2: CGPoint(x: 200, y: y - 190))
        arcPath.addLine(to: CGPoint(x: x, y: y))//MaxHeight
        arcPath.addLine(to: CGPoint(x: 0.0, y: y))//MaxHeight
        arcPath.close()
        return arcPath
    }
    
    var arcPathHigh: UIBezierPath {
        var arcPath = UIBezierPath()
        arcPath.move(to: CGPoint(x: 0.0, y: y))
        arcPath.addLine(to: CGPoint(x: 0.0, y: y - 300))
        arcPath.addCurve(to: CGPoint(x: x, y: y - 300), controlPoint1: CGPoint(x: 100.0, y: y - 290), controlPoint2: CGPoint(x: 200.0, y: y - 320))
        arcPath.addLine(to: CGPoint(x: x, y: y))
        arcPath.addLine(to: CGPoint(x: 0.0, y: y))
        arcPath.close()
        return arcPath
    }
    
    var arcPathComplete: UIBezierPath {
        var arcPath = UIBezierPath()
        arcPath.move(to: CGPoint(x: 0.0, y: y))
        arcPath.addLine(to: CGPoint(x: 0.0, y: -5.0))
        arcPath.addLine(to: CGPoint(x: x, y: -5.0))
        arcPath.addLine(to: CGPoint(x: x, y: y))
        arcPath.addLine(to: CGPoint(x: 0.0, y: y))
        arcPath.close()
        return arcPath
    }
    
    func animate() {
        var arcAnimationPre: CABasicAnimation = CABasicAnimation(keyPath: "path")
        arcAnimationPre.fromValue = arcPathPre.cgPath
        arcAnimationPre.toValue = arcPathStarting.cgPath
        arcAnimationPre.beginTime = 0.0
        arcAnimationPre.duration = animationDuration
        
        var arcAnimationLow: CABasicAnimation = CABasicAnimation(keyPath: "path")
        arcAnimationLow.fromValue = arcPathStarting.cgPath
        arcAnimationLow.toValue = arcPathLow.cgPath
        arcAnimationLow.beginTime = arcAnimationPre.beginTime + arcAnimationPre.duration
        arcAnimationLow.duration = animationDuration
        
        var arcAnimationMid: CABasicAnimation = CABasicAnimation(keyPath: "path")
        arcAnimationMid.fromValue = arcPathLow.cgPath
        arcAnimationMid.toValue = arcPathMid.cgPath
        arcAnimationMid.beginTime = arcAnimationLow.beginTime + arcAnimationLow.duration
        arcAnimationMid.duration = animationDuration
        
        var arcAnimationHigh: CABasicAnimation = CABasicAnimation(keyPath: "path")
        arcAnimationHigh.fromValue = arcPathMid.cgPath
        arcAnimationHigh.toValue = arcPathHigh.cgPath
        arcAnimationHigh.beginTime = arcAnimationMid.beginTime + arcAnimationMid.duration
        arcAnimationHigh.duration = animationDuration
        
        var arcAnimationComplete: CABasicAnimation = CABasicAnimation(keyPath: "path")
        arcAnimationComplete.fromValue = arcPathHigh.cgPath
        arcAnimationComplete.toValue = arcPathComplete.cgPath
        arcAnimationComplete.beginTime = arcAnimationHigh.beginTime + arcAnimationHigh.duration
        arcAnimationComplete.duration = animationDuration
        
        var arcAnimationGroup: CAAnimationGroup = CAAnimationGroup()
        arcAnimationGroup.animations = [arcAnimationPre, arcAnimationLow, arcAnimationMid,
                                        arcAnimationHigh, arcAnimationComplete]
        arcAnimationGroup.duration = arcAnimationComplete.beginTime + arcAnimationComplete.duration
        arcAnimationGroup.fillMode = kCAFillModeForwards
        arcAnimationGroup.isRemovedOnCompletion = false
        add(arcAnimationGroup, forKey: nil)
    }
}
