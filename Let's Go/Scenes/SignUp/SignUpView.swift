//
//  SignUpView.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 02.09.2023.
//

import UIKit

final class SignUpView: UIView {
    
    let vStackView = UIStackView(axis: .vertical, spacing: 25)
    let nameTextField = UnderlinedTextField()
    let emailTextField = UnderlinedTextField()
    let passwordTextField = UnderlinedTextField()
    let showPasswordButton = UIButton()
    let signUpButton = UIButton()
    let signUpLabel = UILabel()
    let passwordRulesLabel = UILabel()
    let nameIsOptionalLabel = UILabel()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        layout()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubviews(vStackView)
        vStackView.addArrangedSubviews(signUpLabel, nameTextField, nameIsOptionalLabel, emailTextField, passwordTextField, passwordRulesLabel, signUpButton)
        vStackView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(75)
            $0.center.equalToSuperview()
        }
        vStackView.setCustomSpacing(10, after: signUpLabel)
        vStackView.setCustomSpacing(10, after: nameTextField)
        vStackView.setCustomSpacing(10, after: passwordTextField)
    }
    
    private func setStyle() {
        backgroundColor = .letsgo_main_gray

        emailTextField.emailStyle()
        passwordTextField.securedEntryStyle()
        showPasswordButton.setImage(Images.eye_fill, for: .normal)
        passwordTextField.rightView = showPasswordButton
        nameTextField.nameStyle()
        
        signUpLabel.text = Strings.create_an_account
        signUpLabel.font = .letsgo_title3().bolded
        signUpLabel.textColor = .letsgo_white
        
        signUpButton.sighUpStyle()
        
        passwordRulesLabel.font = .letsgo_caption2()
        passwordRulesLabel.textColor = .letsgo_light_gray
        passwordRulesLabel.text = Strings.not_less_than_eight_characters
        
        nameIsOptionalLabel.font = .letsgo_caption2()
        nameIsOptionalLabel.textColor = .letsgo_light_gray
        nameIsOptionalLabel.text = Strings.optional.capitalized
    }
    
    
}
