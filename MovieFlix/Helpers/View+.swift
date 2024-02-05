//
//  View+.swift
//  MovieFlix
//
//  Created by Vasilis Polyzos on 2/2/24.
//

import Foundation
import UIKit

public typealias SimpleClosure = (() -> ())
private var tappableKey : UInt8 = 0
private var actionKey : UInt8 = 1

extension UIView {
    var didTapped: SimpleClosure? {
        get {
            return objc_getAssociatedObject(self, &actionKey) as? SimpleClosure
        }
        set(newValue) {
            objc_setAssociatedObject(self, &actionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var globalGesture: UITapGestureRecognizer {
        get {
            return UITapGestureRecognizer(target: self, action: #selector(tapped))
        }
    }
    
    var globalGestureWithoutAnimation: UITapGestureRecognizer {
        get {
            return UITapGestureRecognizer(target: self, action: #selector(simpleTapped))
        }
    }
    
    var tappableWithOutAnimation: Bool? {
        get {
            return objc_getAssociatedObject(self, &tappableKey) as? Bool
        }
        set(newValue) {
            objc_setAssociatedObject(self, &tappableKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            guard newValue == true else { return }
            self.addTapGesture(withAnimation: false)
        }
    }
    
    var tappable: Bool! {
        get {
            return (objc_getAssociatedObject(self, &tappableKey) as? Bool) ?? false
        }
        set(newValue) {
            objc_setAssociatedObject(self, &tappableKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            guard newValue == true else { return }
            self.addTapGesture(withAnimation: true)
        }
    }
    
    fileprivate func addTapGesture(withAnimation: Bool) {
        if (self.tappable || tappableWithOutAnimation == true) {
            self.isUserInteractionEnabled = true
            guard withAnimation else {
                self.globalGestureWithoutAnimation.numberOfTapsRequired = 1
                self.addGestureRecognizer(globalGestureWithoutAnimation)
                return
            }
            self.globalGesture.numberOfTapsRequired = 1
            self.addGestureRecognizer(globalGesture)
        }
    }
    
    @objc private func tapped() {
        guard tappable else { return }
        self.isUserInteractionEnabled = false
        self.startBounceAnimation() { [weak self, completion = self.didTapped] _ in
            guard let self = self else { return }
            self.isUserInteractionEnabled = true
            guard let didTapped = completion else { return }
            didTapped()
        }
    }
    
    @objc private func simpleTapped() {
        guard tappable else { return }
        guard let didTapped = self.didTapped else { return }
        didTapped()
    }
}

protocol BounceView {
    func startBounceAnimation(onComplete: @escaping ViewEffectAnimatorComplete, withFeedback: Bool )
    func startScaleAnimation(onComplete: @escaping ViewEffectAnimatorComplete, scaleSize: CGFloat, duration: TimeInterval, withFeedback: Bool )
}


extension UIView: BounceView {
    func startBounceAnimation(onComplete: @escaping ViewEffectAnimatorComplete, withFeedback: Bool = true ) {
        let bounce = BounceAnimation(targetView: self, onComplete: onComplete, duration: 0.1, withFeedback: withFeedback)
        bounce.startAnimation()
    }
    
    func startScaleAnimation(onComplete: @escaping ViewEffectAnimatorComplete, scaleSize: CGFloat, duration: TimeInterval = 0.1, withFeedback: Bool = true) {
        let scale = ScaleAnimation(targetView: self, onComplete: onComplete, scaleSize: scaleSize, duration: duration)
        scale.startAnimation()
    }
}

struct BounceAnimation: ViewEffectAnimatorType {
    
    let animator: UIViewPropertyAnimator
    
    init(targetView: UIView, onComplete: @escaping ViewEffectAnimatorComplete, scaleSize: CGFloat, duration: TimeInterval) {
        self.init(targetView: targetView, onComplete: onComplete, duration: 0.1)
    }
    
    init(targetView: UIView, onComplete: @escaping ViewEffectAnimatorComplete) {
        self.init(targetView: targetView, onComplete: onComplete, duration: 0.1)
    }
    
    init(targetView: UIView, onComplete: @escaping ViewEffectAnimatorComplete, duration: TimeInterval) {
        self.init(targetView: targetView, onComplete: onComplete, duration: duration, withFeedback: true)
    }
    
    init(targetView: UIView, onComplete: @escaping ViewEffectAnimatorComplete, duration: TimeInterval, withFeedback: Bool = true) {
        let downAnimationTiming = UISpringTimingParameters(dampingRatio: 0.9, initialVelocity: CGVector(dx: 20, dy: 0))
        self.animator = UIViewPropertyAnimator(duration: duration/2, timingParameters: downAnimationTiming)
        self.animator.addAnimations {
            targetView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
        self.animator.addCompletion { position in
            let upAnimationTiming = UISpringTimingParameters(dampingRatio: 0.3, initialVelocity:CGVector(dx: 20, dy: 0))
            let upAnimator = UIViewPropertyAnimator(duration: duration/2, timingParameters: upAnimationTiming)
            upAnimator.addAnimations {
                targetView.transform = CGAffineTransform.identity
            }
            upAnimator.addCompletion(onComplete)
            upAnimator.startAnimation()
        }
    }
}

struct ScaleAnimation: ViewEffectAnimatorType {
    let animator: UIViewPropertyAnimator
    
    init(targetView: UIView, onComplete: @escaping ViewEffectAnimatorComplete, scaleSize: CGFloat, duration: TimeInterval) {
        let downAnimationTiming = UISpringTimingParameters(dampingRatio: 0.9, initialVelocity: CGVector(dx: 20, dy: 0))
        self.animator = UIViewPropertyAnimator(duration: duration/2, timingParameters: downAnimationTiming)
        self.animator.addAnimations {
            targetView.transform = CGAffineTransform(scaleX: scaleSize, y: scaleSize)
        }
        self.animator.addCompletion { position in
            let upAnimationTiming = UISpringTimingParameters(dampingRatio: 0.3, initialVelocity:CGVector(dx: 20, dy: 0))
            let upAnimator = UIViewPropertyAnimator(duration: duration/2, timingParameters: upAnimationTiming)
            upAnimator.addAnimations {
                targetView.transform = CGAffineTransform.identity
            }
            upAnimator.addCompletion(onComplete)
            upAnimator.startAnimation()
        }
    }
    init(targetView: UIView, onComplete: @escaping ViewEffectAnimatorComplete) {
        self.init(targetView: targetView, onComplete: onComplete, scaleSize: 0.95, duration: 0.1)
    }
    
    init(targetView: UIView, onComplete: @escaping ViewEffectAnimatorComplete, duration: TimeInterval) {
        self.init(targetView: targetView, onComplete: onComplete, scaleSize: 0.95, duration: 0.1)
    }
    
    init(targetView: UIView, onComplete: @escaping ViewEffectAnimatorComplete, duration: TimeInterval, withFeedback: Bool = true) {
        self.init(targetView: targetView, onComplete: onComplete, scaleSize: 0.95, duration: 0.1)
    }
    
}

typealias ViewEffectAnimatorComplete = (UIViewAnimatingPosition) -> Void

protocol ViewEffectAnimatorType {
    
    var animator: UIViewPropertyAnimator { get }
    
    init(targetView: UIView, onComplete: @escaping ViewEffectAnimatorComplete)
    init(targetView: UIView, onComplete: @escaping ViewEffectAnimatorComplete, duration: TimeInterval)
    init(targetView: UIView, onComplete: @escaping ViewEffectAnimatorComplete, scaleSize: CGFloat, duration: TimeInterval)
    init(targetView: UIView, onComplete: @escaping ViewEffectAnimatorComplete, duration: TimeInterval, withFeedback: Bool)
    
    func startAnimation()
}

extension ViewEffectAnimatorType {
    func startAnimation() {
        animator.startAnimation()
    }
}
