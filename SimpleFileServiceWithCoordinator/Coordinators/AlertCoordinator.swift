//
//  AlertCoordinator.swift
//  SimpleFileServiceWithCoordinator
//
//  Created by Николай Завгородний on 10.07.2025.
//

import UIKit

final class AlertCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private weak var presentingViewController: UIViewController?
    
    var onFinish: (() -> Void)?
    
    init(navigationController: UINavigationController,
         presentingViewController: UIViewController?) {
        self.navigationController = navigationController
        self.presentingViewController = presentingViewController ?? navigationController.topViewController
    }
    
    func start() {}
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.onFinish?()
        }
        
        alert.addAction(okAction)
        presentingViewController?.present(alert, animated: true)
    }
    
    func showConfirmationAlert(
        title: String,
        message: String,
        onConfirm: @escaping () -> Void
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let noAction = UIAlertAction(title: "Нет", style: .cancel) { [weak self] _ in
            self?.onFinish?()
        }
        
        let okAction = UIAlertAction(title: "ОК", style: .destructive) { [weak self] _ in
            onConfirm()
            self?.onFinish?()
        }
        
        alert.addAction(noAction)
        alert.addAction(okAction)
        
        presentingViewController?.present(alert, animated: true)
    }
}
