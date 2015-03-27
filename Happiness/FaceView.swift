//
//  FaceView.swift
//  Happiness
//
//  Created by Alexandre THOMAS on 19/03/15.
//  Copyright (c) 2015 Alexandre THOMAS. All rights reserved.
//

import UIKit


protocol FaceViewDataSource: class {
    func smilinessForFaceView(sender: FaceView) -> Double? // -1 to 1
}

@IBDesignable
class FaceView: UIView
{
    
    @IBInspectable
    var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var faceScale: CGFloat = 0.9 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var faceRotation: CGFloat = 0 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var color: UIColor = UIColor.blueColor()

    var faceCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
    var faceRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * faceScale
    }
    
    weak var dataSource: FaceViewDataSource?
    
    private struct Scaling {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
    }
    
    private enum Eye { case Left, Right }


    private func bezierPathForEye(whichEye: Eye) -> UIBezierPath {
        
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        
        switch whichEye {
            case .Left: eyeCenter.x -= eyeHorizontalSeparation / 2
            case .Right: eyeCenter.x += eyeHorizontalSeparation / 2
        }
        
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }

    
    func bezierPathForSmile(fractionOfMaxSmile: Double) -> UIBezierPath {
       
        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
        
        var smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeight
        
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    func rotateBezierPath(path: UIBezierPath, angle: CGFloat) -> UIBezierPath {
        var resultPath = path
        
        let bounds = CGPathGetBoundingBox(resultPath.CGPath)
        //let center = CGPoint(x:CGRectGetMidX(bounds), y:CGRectGetMidY(bounds))
        let toOrigin = CGAffineTransformMakeTranslation(-center.x, -center.y)
        resultPath.applyTransform(toOrigin)
        let rotation = CGAffineTransformMakeRotation(angle)
        resultPath.applyTransform(rotation)
        let fromOrigin = CGAffineTransformMakeTranslation(center.x, center.y)
        resultPath.applyTransform(fromOrigin)

        return resultPath
    }
    

    override func drawRect(rect: CGRect)
    {
        
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        facePath.lineWidth = lineWidth
        
        let smiliness = dataSource?.smilinessForFaceView(self) ?? 0.0
        color = UIColor(red: CGFloat(1.0 - (smiliness / 2 + 0.5)), green: CGFloat(smiliness / 2 + 0.5), blue: 0, alpha: 1)
        color.set()
        facePath.stroke()
        
        rotateBezierPath(bezierPathForEye(Eye.Left), angle: faceRotation).stroke()
        rotateBezierPath(bezierPathForEye(Eye.Right), angle: faceRotation).stroke()
        rotateBezierPath(bezierPathForSmile(smiliness), angle: faceRotation).stroke()
    }

    func scale(gesture: UIPinchGestureRecognizer)
    {
        if gesture.state == .Changed {
            faceScale *= gesture.scale
            lineWidth *=  gesture.scale
            gesture.scale = 1
        }
    }
    
    
    
    func rotate(gesture: UIRotationGestureRecognizer) {
        switch gesture.state{
        case .Ended: fallthrough
        case .Changed:
            faceRotation += gesture.rotation
            gesture.rotation = 0
        default:break
        }
        
        
        
    }


}
