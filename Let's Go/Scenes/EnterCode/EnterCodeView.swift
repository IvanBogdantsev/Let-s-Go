//
//  EnterCodeView.swift
//  Let's Go
//
//  Created by Timur Israilov on 11/03/24.
//

import UIKit

final class EnterCodeView: UIView {
    // MARK: - UI Elements
    private lazy var timerTitleLabel: UILabel = {
        $0.textColor = UIColor(resource: .mainBlack)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.text = "Отправить повторно через"
        return $0
    }(UILabel())
    
    private lazy var timerCounterLabel: UILabel = {
        $0.textColor = UIColor(resource: .mainBlack)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 12, weight: .bold)
        $0.text = "00:59"
        return $0
    }(UILabel())
    
    private lazy var subtitleLabel: UILabel = {
        $0.textColor = UIColor(resource: .mainBlack)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.text = "В течение 30 секунд Вам поступит звонок, введите последние 4 цифры входящего номера телефона"
        return $0
    }(UILabel())
    
    private(set) lazy var loginButton: UIButton = {
        $0.setTitle("Вход", for: .normal)
        $0.backgroundColor = UIColor(resource: .gray300)
        $0.setTitleColor(UIColor(resource: .gray500), for: .disabled)
        $0.setTitleColor(UIColor(resource: .mainWhite), for: .normal)
        $0.isEnabled = false
        $0.layer.cornerRadius = 6
        return $0
    }(UIButton())
    
    private(set) lazy var sendCodeAgaingButton: UIButton = {
        $0.setTitle("Отправить повторно", for: .normal)
        $0.setTitleColor(UIColor(resource: .mainPink), for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        $0.isHidden = true
        return $0
    }(UIButton())
    
    private(set) lazy var codeTextField: CodeEnterView = {
        $0.length = 4
        return $0
    }(CodeEnterView())
    
    // MARK: - Private properties
    private var timer: Timer?
    private var secondsRemaining = 59
    
    // MARK: - Override methods
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupUI()
        setAgainCodeButton(true)
        startTimer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - UI methods
    private func setupUI() {
        backgroundColor = UIColor(resource: .mainWhite)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapViewAction)))
        addSubviews(
            subtitleLabel,
            codeTextField,
            timerTitleLabel,
            timerCounterLabel,
            loginButton,
            sendCodeAgaingButton
        )
        setupSubtitleLabel()
        setupCodeView()
        setupTimerTitleLabel()
        setupTimerCounterLabel()
        setupLoginButton()
        setupSendCodeAgaingButton()
    }
    
    private func setupSendCodeAgaingButton() {
        sendCodeAgaingButton.snp.makeConstraints { make in
            make.top.equalTo(codeTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupLoginButton() {
        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(46)
        }
    }
    
    private func setupTimerCounterLabel() {
        timerCounterLabel.snp.makeConstraints { make in
            make.top.equalTo(timerTitleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupTimerTitleLabel() {
        timerTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(codeTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupCodeView() {
        codeTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(36)
        }
    }
    private func setupSubtitleLabel() {
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Private Methods
    private func updateUI() {
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        timerCounterLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }

    private func setAgainCodeButton(_ isHidden: Bool) {
        timerCounterLabel.isHidden = !isHidden
        timerTitleLabel.isHidden = !isHidden
        sendCodeAgaingButton.isHidden = isHidden
    }
    // MARK: - Public Methods
    func setIsValid(_ isValid: Bool) {
        loginButton.backgroundColor = UIColor(resource: isValid ? .mainBlack : .gray300)
        loginButton.isEnabled = isValid
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        setAgainCodeButton(false)
    }

    func startTimer() {
        secondsRemaining = 59
        updateUI()
        setAgainCodeButton(true)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    // MARK: - Actions
    @objc private func tapViewAction() {
        endEditing(true)
    }
    
    @objc private func updateTimer() {
        if secondsRemaining > 0 {
            secondsRemaining -= 1
            updateUI()
        } else {
            stopTimer()
        }
    }
}
