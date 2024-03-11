//
//  CodeItemView.swift
//  Let's Go
//
//  Created by Timur Israilov on 11/03/24.
//
import UIKit

final class CodeItemView: UIView {
    // MARK: - UI Elements
    private(set) lazy var textField: CodeTextField = {
        $0.keyboardType = .numberPad
        $0.textAlignment = .center
        return $0
    }(CodeTextField())
    // MARK: - Init
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Override Methods
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
    // MARK: - UI Methods
    private func setupUI() {
        textField.text = ""
        isUserInteractionEnabled = false
        addSubview(textField)
        setupSelf()
        setupTextField()
        backgroundColor = UIColor(resource: .gray200)
        layer.cornerRadius = 6
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
    }
    private func setupSelf() {
        snp.makeConstraints { make in
            make.width.equalTo(65)
            make.height.equalTo(46)
        }
    }
    private func setupTextField() {
        textField.snp.makeConstraints { make in
            make.leading.centerY.trailing.equalToSuperview()
        }
    }
}
