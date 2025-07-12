//
//  MainCoordinator.swift
//  SimpleFileServiceWithCoordinator
//
//  Created by Николай Завгородний on 10.07.2025.
//

import UIKit
import SnapKit

final class InformationViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var clearAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Удалить все", for: .normal)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    private var textFields: [UITextField] = []
    private var deleteButtons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        loadData()
    }
    
    private func setupView() {
        title = "Информация"
        view.backgroundColor = .systemBackground
        
        clearAllButton.addTarget(self, action: #selector(clearAll), for: .touchUpInside)
        
        view.addSubview(stackView)
        view.addSubview(clearAllButton)
        
        let labels = ["Логин", "Пароль", "Номер", "Имя"]
        for label in labels {
            let field = createTextField()
            field.placeholder = label
            field.isUserInteractionEnabled = false
            textFields.append(field)
            
            let button = createDeleteButton()
            deleteButtons.append(button)
            
            let hStack = UIStackView(arrangedSubviews: [field, button])
            hStack.spacing = 8
            stackView.addArrangedSubview(hStack)
        }
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        clearAllButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }
    
    private func createTextField() -> UITextField {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        return tf
    }
    
    private func createDeleteButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .systemRed
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(deleteField(_:)), for: .touchUpInside)
        return button
    }
    
    private func loadData() {
        guard let data = FileService.shared.loadUserData() else { return }
        
        textFields[0].text = data.login
        textFields[1].text = data.password
        textFields[2].text = data.phone
        textFields[3].text = data.name
    }
    
    @objc private func deleteField(_ sender: UIButton) {
        guard let index = deleteButtons.firstIndex(of: sender) else { return }
        
        let fieldName: String
        switch index {
        case 0: fieldName = "логин"
        case 1: fieldName = "пароль"
        case 2: fieldName = "номер"
        case 3: fieldName = "имя"
        default: fieldName = ""
        }
        
        coordinator?.showConfirmationAlert(
            title: "Подтверждение",
            message: "Точно удалить \(fieldName)?",
            onConfirm: { [weak self] in
                self?.performDeleteField(at: index)
            }
        )
    }
    
    private func performDeleteField(at index: Int) {
        textFields[index].text = ""
        
        guard var data = FileService.shared.loadUserData() else { return }
        
        switch index {
        case 0: data.login = ""
        case 1: data.password = ""
        case 2: data.phone = ""
        case 3: data.name = ""
        default: break
        }
        
        if FileService.shared.saveUserData(
            login: data.login,
            password: data.password,
            phone: data.phone,
            name: data.name
        ) {
            coordinator?.showAlert(title: "Успешно", message: "Данные удалены")
        }
    }
    
    @objc private func clearAll() {
        coordinator?.showConfirmationAlert(
            title: "Подтверждение",
            message: "Точно удалить все данные?",
            onConfirm: { [weak self] in
                self?.performClearAll()
            }
        )
    }
    
    private func performClearAll() {
        textFields.forEach { $0.text = "" }
        if FileService.shared.clearUserData() {
            coordinator?.showAlert(title: "Успешно", message: "Все данные удалены")
        }
    }
}
