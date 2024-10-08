//
//  AlertSaveSuccessViewController.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

final class AlertSaveSuccessViewController: UIViewController {
    static var shared = AlertSaveSuccessViewController()
    
    func showAlert() {
        let alertController = UIAlertController(
            title: "Success",
            message: "Save was successful",
            preferredStyle: .alert
        )
        
        let doneAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(doneAction)
        
        if let scene = UIApplication.shared.connectedScenes.first(where: {$0.activationState == .foregroundActive}) as? UIWindowScene,
           let rootViewController = scene.windows.first?.rootViewController {
            rootViewController.present(alertController, animated: true, completion: nil)
        }
    }
}
