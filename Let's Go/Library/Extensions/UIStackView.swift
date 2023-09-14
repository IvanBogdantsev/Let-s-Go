//
//  UIStackView.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 21.08.2023.
//

import UIKit.UIStackView

extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0) {
        self.init()
        self.axis = axis
        self.spacing = spacing
    }
    
    func addArrangedSubviews(_ subviews: UIView...) {
        subviews.forEach { addArrangedSubview($0) }
    }
}
