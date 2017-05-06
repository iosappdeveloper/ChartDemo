//
//  ChartTableViewCell.swift
//  ChartDemo
//
//  Created by Matoria, Ashok on 5/3/17.
//  Copyright © 2017 Matoria, Ashok. All rights reserved.
//

import UIKit

class ChartTableViewCell: UITableViewCell {
    var profileViewPosition: CGPoint?
    var profileView: ProfileView!
    let startAngle: Double = 60
    let endAngle: Double = 120
    var arcRadius: CGFloat = 0
    var arcCenter: CGPoint {
        get {
            return CGPoint(x: center.x, y: center.y - arcRadius)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        // Arc's radius is equal to width of the cell
        arcRadius = bounds.width
        // Redraw circular arc
        drawArc()
        // Remove the previous profile view
        contentView.subviews.forEach {
            if $0 is ProfileView {
                $0.removeFromSuperview()
            }
        }
        // Add a profile view at the center of arc parameter
        profileView = createProfileView()
        contentView.addSubview(profileView)
        if profileViewPosition == nil {
            // TODO: Actually it should be calculated as center of arc. For now, we know center of arc coincides with center of cell
            profileViewPosition = CGPoint(x: center.x, y: center.y)
        }
        move(view: profileView, at: profileViewPosition!)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveProfileViewOverArc(with:)))
        profileView.addGestureRecognizer(panGesture)
    }
}

fileprivate extension ChartTableViewCell {
    func createProfileView() -> ProfileView {
        let rect = CGRect(x: 0, y: 0, width: 20, height: 20)
        let profileView = ProfileView(frame: rect)
        profileView.backgroundColor = UIColor.red.withAlphaComponent(0.5)   // with some transparency
        return profileView
    }
    func move(view: UIView, at point: CGPoint) {
        view.center = point
    }
    func profilePositionInContentView(point: CGPoint) -> CGPoint {
        let xDelta = abs(center.x - point.x)
        let relativeAngle = atan(pow(xDelta, 2)/pow(arcRadius, 2))  // x^2/r^2 = tan(angle)
        let relativeAngleInDegrees = radiansToDegrees(value: relativeAngle)
        let actualAngleInDegrees = 90 - relativeAngleInDegrees // 90 implies (startAngle + endAngle) / 2
        let actualAngleInRadians = degreesToRadians(value: actualAngleInDegrees)
        let newCenterY = (center.y - arcRadius) + (arcRadius * sin(actualAngleInRadians))
        return CGPoint(x: point.x, y: newCenterY)
    }
    @objc fileprivate func moveProfileViewOverArc(with gesture: UIPanGestureRecognizer) {
        let point = gesture.location(in: contentView);
        let xDelta = abs(center.x - point.x)
        let relativeAngle = atan(pow(xDelta, 2)/pow(arcRadius, 2))  // x^2/r^2 = tan(angle)
        let relativeAngleInDegrees = radiansToDegrees(value: relativeAngle)
        let actualAngleInDegrees = 90 - relativeAngleInDegrees   // 90 = startAngle + endAngle / 2
        let actualAngleInRadians = degreesToRadians(value: actualAngleInDegrees)
        // parametric equation of circle
        // x = cx + r * cos(a)
        // y = cy + r * sin(a)
        let newCenterY = (center.y - arcRadius) + (arcRadius * sin(actualAngleInRadians))
        profileViewPosition = CGPoint(x: point.x, y: newCenterY)
        move(view: profileView, at: profileViewPosition!)
    }
    func drawArc() {
        contentView.layer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
        // Create an arc
        let path = UIBezierPath(arcCenter: arcCenter,
                                radius: arcRadius,
                                startAngle: degreesToRadians(value: startAngle),
                                endAngle: degreesToRadians(value: endAngle),
                                clockwise: true)
        // Create a shape layer and add path
        let shapeLayer = createShapeLayer()
        shapeLayer.path = path.cgPath
        contentView.layer.addSublayer(shapeLayer)
    }
    func createShapeLayer() -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 1.0
        shapeLayer.zPosition = -1
        return shapeLayer
    }
    func degreesToRadians(value: Double) -> CGFloat {
        return CGFloat(value * .pi / 180.0)
    }
    func radiansToDegrees(value: CGFloat) -> Double {
        return Double(value * 180.0 / .pi)
    }
}

class ProfileView: UIView {
}
