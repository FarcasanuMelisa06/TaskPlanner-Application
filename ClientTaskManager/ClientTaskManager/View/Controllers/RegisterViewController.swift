//
//  RegisterViewController.swift
//  ClientTaskManager
//
//  Created by Melisa Farcasanu on 25.07.2023.
//

import Foundation
import UIKit
class RegisterViewController: UIViewController, ManagerInjector{
    
    @IBOutlet weak var registerName: UILabel!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var createAccount: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        password.isSecureTextEntry = true
        createAccount.layer.cornerRadius = 10
        createAccount.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        
        registerName.font = UIFont(name: "Helvetica-BoldOblique", size: 25)
        
        self.setupHideKeyboardOnTap()
    }
    
    @IBAction func registerAccount(_ sender: Any) {
        let service = AppService()
        Task(priority: .background) {
            let result = await service.register(name: name.text ?? "", email: email.text ?? "", password: password.text ?? "")
            switch result {
            case .success(let response):
                print("Register cu succes \(response.token)")
                manager.token = response.token
                performSegue(withIdentifier: "goToTasksSegue", sender: nil)
            case .failure(let error):
                print("Eroare \(error)")
            }
        }
    }

}
