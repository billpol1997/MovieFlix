//
//  Borderable.swift
//  MovieFlix
//
//  Created by Vasilis Polyzos on 1/2/24.
//

import Foundation
import UIKit

enum ViewRoundedSides {
    case all(radius:CGFloat = 4.0)
    case left(radius:CGFloat = 4.0)
    case right(radius:CGFloat = 4.0)
    case bottom(radius:CGFloat = 4.0)
    case top(radius:CGFloat = 4.0)
}

struct ViewShadowConfig {
    var radius: CGFloat = 1.0
    var offset: CGSize = .zero
    var opacity: Float = 0.2
    var color: UIColor = UIColor(red: 0.039, green: 0.075, blue: 0.141, alpha: 0.5)
}

protocol Borderable {
    
    /// A UIView with border line around it
    ///
    /// - Parameters:
    ///   - color: The color of border line
    ///   - borderWidth: The size of border line
    func bordered(color: UIColor, borderWidth: CGFloat)
    
    func bordered(color: UIColor, borderWidth: CGFloat, withPadding: CGFloat)
    
    func removeBorder()
    
    func rounded(cornerRadius: CGFloat)
    
    func roundTopCorners(radius: CGFloat)
    
    func roundBottomCorners(radius: CGFloat)
    
    func circle()
}

extension Borderable where Self: UIView {
    
    /// A UIView with border line around it
    ///
    /// - Parameters:
    ///   - color: The color of border line, the default is white
    ///   - borderWidth: The size of border line, the default is 2.0
    func bordered(color: UIColor = UIColor.white, borderWidth: CGFloat = 1.0) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
    }
    
    func bordered(color: UIColor, borderWidth: CGFloat, withPadding: CGFloat) {
        self.layoutMargins = UIEdgeInsets.init(top: withPadding, left: withPadding,
                                               bottom: withPadding, right: withPadding)
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
    }
    
    func removeBorder() {
        self.layer.borderWidth = 0
    }
    
    func removeRounded() {
        self.layer.cornerRadius = 0
    }
    
    func rounded(cornerRadius: CGFloat = 4.0) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner ,.layerMaxXMaxYCorner]
    }
    
    func roundTopCorners(radius: CGFloat = 4.0){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func roundTopLeftCorner(radius: CGFloat = 4.0) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner]
    }
    
    func roundTopRightCorner(radius: CGFloat = 4.0) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMaxXMinYCorner]
    }
    
    func roundBottomCorners(radius: CGFloat = 4.0){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func roundBottomLeftCorner(radius: CGFloat = 4.0) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMinXMaxYCorner]
    }
    
    func roundBottomRightCorner(radius: CGFloat = 4.0) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMaxXMaxYCorner]
    }
    
    func roundRightCorners(radius: CGFloat = 4.0){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    func roundLeftCorners(radius: CGFloat = 4.0){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    func roundShadow(_ sides: ViewRoundedSides = .all(radius: 4),_ shadow: ViewShadowConfig = ViewShadowConfig()) {
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = shadow.opacity
        self.layer.shadowOffset = shadow.offset
        self.layer.shadowRadius = shadow.radius
        self.layer.shadowColor = shadow.color.cgColor
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        switch sides {
        case .all(let cornerRadius):
            self.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            self.layer.cornerRadius = cornerRadius
        case .left(let cornerRadius):
            self.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
            self.layer.cornerRadius = cornerRadius
        case .right(let cornerRadius):
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            self.layer.cornerRadius = cornerRadius
        case .top(let cornerRadius):
            self.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            self.layer.cornerRadius = cornerRadius
        case .bottom(let cornerRadius):
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    func circle() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height/2.0
        self.clipsToBounds = true
    }
}

extension UIView: Borderable {}
