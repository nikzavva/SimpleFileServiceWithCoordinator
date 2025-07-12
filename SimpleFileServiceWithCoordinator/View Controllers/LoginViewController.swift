//
//  LoginViewController.swift
//  SimpleFileServiceWithCoordinator
//
//  Created by Николай Завгородний on 10.07.2025.
//

import UIKit
import SnapKit

final class LoginViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var loginTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Логин"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearButtonMode = .whileEditing
        tf.returnKeyType = .next
        return tf
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Пароль"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.clearButtonMode = .whileEditing
        tf.returnKeyType = .done
        return tf
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Дальше", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        title = "Логин и пароль"
        view.backgroundColor = .systemBackground
        
        loginButton.addTarget(self, action: #selector(openNext), for: .touchUpInside)
        
        view.addSubview(stackView)
        [loginTextField, passwordTextField, loginButton].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }

        loginTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }

        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(loginTextField)
        }

        loginButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    @objc private func openNext() {
        guard let login = loginTextField.text?.replacingOccurrences(of: " ", with: ""),
              let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces),
              !login.isEmpty, !password.isEmpty else {
            
            let message: String
            
            switch (loginTextField.text?.isEmpty ?? true, passwordTextField.text?.isEmpty ?? true) {
            case (true, true):
                message = "Ни одно из полей не заполнено"
            case (true, false):
                message = "Поле логина пустое"
            case (false, true):
                message = "Поле пароля пустое"
            default:
                message = "Заполните все поля"
            }
            
            coordinator?.showAlert(title: "Ошибка!", message: message)
            return
        }
        
        UserDefaults.standard.set(login, forKey: "tempLogin")
        UserDefaults.standard.set(password, forKey: "tempPassword")
        
        coordinator?.openNameViewController()
    }
}
