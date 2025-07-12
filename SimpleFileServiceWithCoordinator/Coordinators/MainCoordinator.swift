//
//  MainCoordinator.swift
//  SimpleFileServiceWithCoordinator
//
//  Created by Николай Завгородний on 10.07.2025.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
        
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        openLoginViewController() { vc in
            let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
            vc.navigationItem.backBarButtonItem = backButton
        }
    }
    
    func openLoginViewController(completion: ((UIViewController) -> Void)) {
        let vc = LoginViewController()
        vc.coordinator = self
        completion(vc)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func openNameViewController() {
        let vc = NameViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openInformationViewController() {
        let vc = InformationViewController()
        vc.coordinator = self
        vc.navigationItem.hidesBackButton = true
        
        let rootButton = UIBarButtonItem(
            title: "В начало",
            primaryAction: UIAction { [weak self] _ in
                let loginVC = LoginViewController()
                loginVC.coordinator = self
                
                UserDefaults.standard.removeObject(forKey: "tempLogin")
                UserDefaults.standard.removeObject(forKey: "tempPassword")
                
                self?.showConfirmationAlert(
                    title: "Предупреждение",
                    message: "Вы уверены? Это сотрет все данные",
                    onConfirm: { [weak self] in
                        self?.navigationController.setViewControllers([loginVC], animated: true)
                    }
                )
            }
        )
        
        vc.navigationItem.leftBarButtonItem = rootButton
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        guard let presenter = navigationController.topViewController else { return }
        
        let alertCoordinator = AlertCoordinator(
            navigationController: navigationController,
            presentingViewController: presenter
        )
        
        alertCoordinator.onFinish = { [weak self] in
            self?.removeChildCoordinator(alertCoordinator)
        }
        
        childCoordinators.append(alertCoordinator)
        alertCoordinator.showAlert(title: title, message: message)
    }
    
    func showConfirmationAlert(title: String, message: String, onConfirm: @escaping (() -> Void)) {
        guard let presenter = navigationController.topViewController else { return }
        
        let alertCoordinator = AlertCoordinator(
            navigationController: navigationController,
            presentingViewController: presenter
        )
        
        alertCoordinator.onFinish = { [weak self] in
            self?.removeChildCoordinator(alertCoordinator)
        }
        
        childCoordinators.append(alertCoordinator)
        alertCoordinator.showConfirmationAlert(title: title, message: message, onConfirm: onConfirm)
    }
    
    private func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
    
}
