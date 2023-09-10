//
//  ViewController.swift
//  ClientTaskManager
//
//  Created by Melisa Farcasanu on 25.07.2023.
//

import UIKit

class ViewController: UIViewController, ManagerInjector {
    
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    @IBOutlet weak var login: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        autoLogin()
        
        self.setupHideKeyboardOnTap()
        
        if let buttonLogin = login {
            buttonLogin.customizeButton()
            view.addSubview(buttonLogin)
        }
        
        if let emailTextField = textFieldEmail {
            emailTextField.customizeTextField()
            view.addSubview(emailTextField)
        }
        
        
        if let passwordTextField = textFieldPassword {
            passwordTextField.customizeTextField()
            textFieldPassword.isSecureTextEntry = true
            view.addSubview(passwordTextField)
        }
        
        
        if let titleLabel = appName {
            titleLabel.customizeLabel()
            view.addSubview(titleLabel)
        }
        
   
    }
    
    @IBAction func loginButton(_ sender: Any) {
        let service = AppService()
        Task(priority: .background) {
            let result = await service.login(email: textFieldEmail.text ?? "", password: textFieldPassword.text ?? "")
            switch result {
            case .success(let response):
                print("Login cu succes \(response.token)")
                manager.token = response.token
                performSegue(withIdentifier: "goToTasksSegue", sender: nil)
            case .failure(let error):
                print("Eroare \(error)")
            }
        }
    }
    
    private func autoLogin() {
        guard let token = manager.token else { return }
        if token != "" {
            performSegue(withIdentifier: "goToTasksSegue", sender: self)
        }
    }
    
    @IBAction func register(_ sender: Any) {
        performSegue(withIdentifier: "goToRegisterSegue", sender: nil)
        
        
    }
    
}
