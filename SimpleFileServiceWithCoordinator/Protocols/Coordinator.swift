//
//  Coordinator.swift
//  SimpleFileServiceWithCoordinator
//
//  Created by Николай Завгородний on 10.07.2025.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get }
    var navigationController: UINavigationController { get }
    func start()
}
