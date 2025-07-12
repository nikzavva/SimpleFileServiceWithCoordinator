//
//  NameViewController.swift
//  SimpleFileServiceWithCoordinator
//
//  Created by Николай Завгородний on 10.07.2025.
//

import UIKit
import SnapKit

final class NameViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var numberTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Номер телефона"
        tf.keyboardType = .phonePad
        tf.borderStyle = .roundedRect
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearButtonMode = .whileEditing
        tf.returnKeyType = .next
        return tf
    }()
    
    private lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Имя"
        tf.borderStyle = .roundedRect
        tf.autocorrectionType = .no
        tf.clearButtonMode = .whileEditing
        tf.returnKeyType = .done
        return tf
    }()
    
    private lazy var nameButton: UIButton = {
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
        title = "Телефон и имя"
        view.backgroundColor = .systemBackground
        
        nameButton.addTarget(self, action: #selector(openNext), for: .touchUpInside)
        
        view.addSubview(stackView)
        [numberTextField, nameTextField, nameButton].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        numberTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(numberTextField)
        }
        
        nameButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    @objc private func openNext() {
        guard let phone = numberTextField.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(),
              let name = nameTextField.text?.trimmingCharacters(in: .whitespaces),
              !phone.isEmpty, !name.isEmpty else {
                
            let message: String
            
            switch (numberTextField.text?.isEmpty ?? true, nameTextField.text?.isEmpty ?? true) {
            case (true, true):
                message = "Ни одно из полей не заполнено"
            case (true, false):
                message = "Поле номера пустое"
            case (false, true):
                message = "Поле имени пустое"
            default:
                message = "Заполните все поля"
            }
            
            coordinator?.showAlert(title: "Ошибка!", message: message)
            return
        }
        
        guard let login = UserDefaults.standard.string(forKey: "tempLogin"),
              let password = UserDefaults.standard.string(forKey: "tempPassword") else {
            coordinator?.showAlert(title: "Ошибка", message: "Сессия истекла. Начните заново.")
            return
        }
        
        if FileService.shared.saveUserData(
            login: login,
            password: password,
            phone: phone,
            name: name
        ) {
            UserDefaults.standard.removeObject(forKey: "tempLogin")
            UserDefaults.standard.removeObject(forKey: "tempPassword")
            
            coordinator?.showConfirmationAlert(
                title: "Подтверждение",
                message: "Данные сохранены. Продолжить?",
                onConfirm: { [weak coordinator] in
                    coordinator?.openInformationViewController()
                }
            )
        } else {
            coordinator?.showAlert(title: "Ошибка", message: "Не удалось сохранить данные")
        }
    }
}
