//
//  CodeEnterView.swift
//  Let's Go
//
//  Created by Timur Israilov on 11/03/24.
//

import Foundation
import UIKit

protocol CodeEnterViewDelegate: AnyObject {
    func codeView(sender: CodeEnterView, didFinishInput code: String) -> Bool
}

final class CodeEnterView: UIControl {
    // MARK: - UI Elements
    private lazy var stackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        return $0
    }(UIStackView())
    private var items: [CodeItemView] = []
    // MARK: - Public Properties
    weak var delegate: CodeEnterViewDelegate?
    var length: Int = 4 {
        didSet {
            setupUI()
        }
    }
    var code: String {
        get {
            let items = stackView.arrangedSubviews.map({$0 as! CodeItemView})
            let values = items.map({$0.textField.text ?? ""})
            return values.joined()
        }
        set {
            let array = newValue.map(String.init)
            for i in 0..<length {
                let item = stackView.arrangedSubviews[i] as! CodeItemView
                item.textField.text = i < array.count ? array[i] : ""
            }
            if !stackView.arrangedSubviews.compactMap({$0 as? UITextField}).filter({$0.isFirstResponder}).isEmpty {
                let _ = becomeFirstResponder()
            }
        }
    }
    // MARK: - Init
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupUI()
        let tap = UITapGestureRecognizer(target: self, action: #selector(becomeFirstResponder))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - UI Methods
    private func setupUI() {
        if stackView.superview == nil {
            addSubview(stackView)
        }
        stackView.snp.makeConstraints({ $0.edges.equalToSuperview() })
        stackView.arrangedSubviews.forEach{($0.removeFromSuperview())}

        for i in 0..<length {
            let itemView = CodeItemView()
            itemView.textField.deleteDelegate = self
            itemView.textField.delegate = self
            itemView.tag = i
            itemView.textField.tag = i
            stackView.addArrangedSubview(itemView)
        }
    }

    // MARK: - Override Methods
    override func becomeFirstResponder() -> Bool {
        let items = stackView.arrangedSubviews
            .map({$0 as! CodeItemView})
        return (items.filter({($0.textField.text ?? "").isEmpty}).first ?? items.last)!.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        stackView.arrangedSubviews.forEach({$0.resignFirstResponder()})
        return true
    }
}
// MARK: - UITextFieldDelegate, CodeTextFieldDelegate
extension CodeEnterView: UITextFieldDelegate, CodeTextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }

        if !textField.hasText {
            let index = textField.tag
            let item = stackView.arrangedSubviews[index] as! CodeItemView
            item.textField.text = string
            item.layer.borderColor = UIColor(resource: .gray500).cgColor
            sendActions(for: .valueChanged)
            if index == length - 1 {
                if (delegate?.codeView(sender: self, didFinishInput: self.code) ?? false) {
                    textField.resignFirstResponder()
                }
                return false
            }
            _ = stackView.arrangedSubviews[index + 1].becomeFirstResponder()
        }
        return false
    }

    func deleteBackward(sender: CodeTextField, prevValue: String?) {
        for i in 1..<length {
            let itemView = stackView.arrangedSubviews[i] as! CodeItemView
            guard itemView.textField.isFirstResponder, (prevValue?.isEmpty ?? true) else {
                continue
            }
            let prevItem = stackView.arrangedSubviews[i-1] as! CodeItemView
            if itemView.textField.text?.isEmpty ?? true {
                prevItem.textField.text = ""
                itemView.layer.borderColor = UIColor.clear.cgColor
                prevItem.layer.borderColor = UIColor.clear.cgColor
                _ = prevItem.becomeFirstResponder()
            }
        }
        sendActions(for: .valueChanged)
    }
}



