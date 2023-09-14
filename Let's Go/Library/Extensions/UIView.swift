//
//  UIView.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 16.08.2023.
//

import UIKit.UIView

extension UIView {
    /// This helper method tries to find a subview of the given class. It returns the first view found, or nil if none are found.
    func findSubview(ofType theClass: AnyClass) -> UIView? {
        for subview in self.subviews {
            if subview.isKind(of: theClass) {
                return subview
            }
        }
        return nil
    }
    
    /// This helper method tries to find all subviews of the given class. It returns an array of views, which is empty if none are found.
    func findSubviews(ofType theClass: AnyClass) -> [UIView] {
        var foundViews = [UIView]()
        for subview in self.subviews {
            if subview.isKind(of: theClass) {
                foundViews.append(subview)
            }
        }
        return foundViews
    }
    
    /// Changes view's alpha to 1.
    func show(animated: Bool, duration: TimeInterval = AnimationDuration.microSlow.timeInterval, completion: ((Bool) -> Void)? = nil) {
        let withDuration: TimeInterval = animated ? duration : 0
        UIView.animate(withDuration: withDuration, animations: {
            self.alpha = 1
        }, completion: completion)
    }
    
    /// Changes view's alpha to 0.
    func hide(animated: Bool, duration: TimeInterval = AnimationDuration.microSlow.timeInterval, completion: ((Bool) -> Void)? = nil) {
        let withDuration: TimeInterval = animated ? duration : 0
        UIView.animate(withDuration: withDuration, animations: {
            self.alpha = 0
        }, completion: completion)
    }
    
    /// adds multiple subviews
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
}
