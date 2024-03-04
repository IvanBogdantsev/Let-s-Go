//
//  LoginView.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 20.08.2023.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

final class LoginView: UIView {
    // MARK: - UI Elements
    private lazy var logoImageView: UIImageView = {
        $0.image = UIImage(resource: .logoBlack)
        return $0
    }(UIImageView())
    
    private lazy var titleTextFieldLabel: UILabel = {
        $0.textColor = UIColor(resource: .mainBlack)
        $0.text = Strings.phone_number
        $0.font = .systemFont(ofSize: 12, weight: .bold)
        return $0
    }(UILabel())
    
    private lazy var phoneTextField: PaddedTextField = {
        $0.textColor = UIColor(resource: .mainBlack)
        $0.backgroundColor = UIColor(resource: .gray200)
        $0.text = "+7"
        $0.keyboardType = .phonePad
        $0.layer.cornerRadius = 6
        $0.delegate = self
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.clear.cgColor
        $0.typingAttributes = [
            .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
        ]
        return $0
    }(PaddedTextField(padding: UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)))
    
    private lazy var checkboxButton: UIButton = {
        $0.setImage(UIImage(resource: .checkboxDisabled), for: .normal)
        $0.addTarget(self, action: #selector(checkboxAction), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var personalDataLabel: UILabel = {
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.text = Strings.accept_personal_data
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private(set) lazy var nextButton: UIButton = {
        $0.setTitle(Strings.continue_title, for: .normal)
        $0.backgroundColor = UIColor(resource: .gray300)
        $0.setTitleColor(UIColor(resource: .gray500), for: .disabled)
        $0.setTitleColor(UIColor(resource: .mainWhite), for: .normal)
        $0.isEnabled = false
        $0.layer.cornerRadius = 6
        return $0
    }(UIButton())
    // MARK: - Private Properties
    private var isCheckboxChecked: Bool = false {
        didSet {
            checkboxChanged.accept(isCheckboxChecked)
        }
    }
    // MARK: - Public Properties
    var checkboxChanged = PublishRelay<Bool>()
    var phoneTextFieldChanged = PublishRelay<String>()
    
    // MARK: - Override methods
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupUI()
    }
    // MARK: - UI methods
    private func setupUI() {
        backgroundColor = UIColor(resource: .mainWhite)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapViewAction)))
        addSubviews(
            logoImageView,
            titleTextFieldLabel,
            phoneTextField,
            checkboxButton,
            personalDataLabel,
            nextButton
        )
        
        setupLogoImageView()
        setupTitleTextFieldLabel()
        setupPhoneTextField()
        setupCheckboxButton()
        setupPersonalDataLabel()
        setupNextButton()
    }
    
    private func setupNextButton() {
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(46)
        }
    }
    
    private func setupPersonalDataLabel() {
        personalDataLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(20)
            make.leading.equalTo(checkboxButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(20)
        }
    }
    
    private func setupCheckboxButton() {
        checkboxButton.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(18)
        }
    }
    
    private func setupPhoneTextField() {
        phoneTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(46)
            make.top.equalTo(titleTextFieldLabel.snp.bottom).offset(10)
        }
    }
    
    private func setupTitleTextFieldLabel() {
        titleTextFieldLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(logoImageView.snp.bottom).offset(40)
        }
    }
    
    private func setupLogoImageView() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(18)
            make.centerX.equalToSuperview()
            make.width.equalTo(128)
            make.height.equalTo(58)
        }
    }
    // MARK: - Public methods
    func setIsValid(_ isValid: Bool) {
        nextButton.backgroundColor = UIColor(resource: isValid ? .mainBlack : .gray300)
        nextButton.isEnabled = isValid
    }
    // MARK: - Private methods
    private func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator
        
        // iterate over the mask characters until the iterator of numbers ends
        if numbers.count > 11 {
            result = numbers
            result.insert("+", at: result.startIndex)
            return result
        }
        
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])
                
                // move numbers iterator to the next index
                index = numbers.index(after: index)
                
            } else {
                result.append(ch) // just append a mask character
            }
        }
        
        return result
    }
    // MARK: - Actions
    @objc private func checkboxAction() {
        isCheckboxChecked.toggle()
        checkboxButton.setImage(UIImage(resource: isCheckboxChecked ? .checkboxEnabled : .checkboxDisabled), for: .normal)
    }
    
    @objc private func tapViewAction() {
        endEditing(true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - UITextFieldDelegate
extension LoginView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(resource: .gray500).cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        phoneTextFieldChanged.accept(textField.text?.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression) ?? "")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format(with: "+X (XXX) XXX-XXXX", phone: newString)
        return false
    }
}
