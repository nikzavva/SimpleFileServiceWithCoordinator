//
//  FileService.swift
//  SimpleFileServiceWithCoordinator
//
//  Created by Николай Завгородний on 11.07.2025.
//

import Foundation

final class FileService {
    static let shared = FileService()
    private init() {}
    
    private let fileManager = FileManager.default
    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    private let fileName = "user_data.txt"
    
    func saveUserData(login: String, password: String, phone: String, name: String) -> Bool {
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        let dataString = "\(login)|\(password)|\(phone)|\(name)"
        
        do {
            try dataString.write(to: fileURL, atomically: true, encoding: .utf8)
            return true
        } catch {
            print("Ошибка сохранения: \(error)")
            return false
        }
    }
    
    func loadUserData() -> (login: String, password: String, phone: String, name: String)? {
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        guard fileManager.fileExists(atPath: fileURL.path),
              let data = try? String(contentsOf: fileURL, encoding: .utf8) else {
            return nil
        }
        
        let components = data.components(separatedBy: "|")
        guard components.count == 4 else { return nil }
        
        return (login: components[0], password: components[1], phone: components[2], name: components[3])
    }
    
    func clearUserData() -> Bool {
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try fileManager.removeItem(at: fileURL)
            return true
        } catch {
            print("Ошибка удаления: \(error)")
            return false
        }
    }
}
