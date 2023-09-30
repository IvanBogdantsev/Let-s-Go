//
//  UnderlinedTextField.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 21.08.2023.
//

import UIKit

final class UnderlinedTextField: UITextField {
    
    let line = UIView()
    
    private var leftPadding: CGFloat {
        (leftView?.frame.width ?? 0) + 5
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: leftPadding, dy: 5)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: leftPadding, dy: 5)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: leftPadding, dy: 5)
    }
    
    private func layout() {
        addSubview(line)
        line.snp.makeConstraints {
            $0.top.equalTo(snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    private func setStyle() {
        line.backgroundColor = Colors.letsgo_white
    }
    
}
