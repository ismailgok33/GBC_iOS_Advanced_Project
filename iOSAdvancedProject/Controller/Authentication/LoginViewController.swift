//
//  ViewController.swift
//  iOSAdvancedProject
//
//  Created by Ismail Gok on 2022-05-21.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // MARK: - Properties
    private var cancellables: Set<AnyCancellable> = []
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfLoggedIn()
        
        receiveChanges()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .quaternaryLabel
        self.title = "Login"
    }
    
    private func checkIfLoggedIn() {
        if let userSession = AuthViewModel.shared.userSession {
            self.goToEventListScreen()
        }
    }
    
    private func receiveChanges() {
        AuthViewModel.shared.$userSession
            .receive(on: RunLoop.main)
            .sink{ updatedData in
                if let userSession = updatedData {
                    self.goToEventListScreen()
                }
            }
            .store(in: &cancellables)
    }
    
    private func goToEventListScreen() {
        if let eventListNav = self.storyboard?.instantiateViewController(withIdentifier: "EventListNavigationController") as? UINavigationController {
            UIApplication.shared.windows.first?.rootViewController = eventListNav
        }
    }
    
    
    // MARK: - Actions
    @IBAction func LoginButtonTapped(_ sender: UIButton) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        AuthViewModel.shared.login(withEmail: email, password: password)
        
    }
    
    @IBAction func SwitchToSignupButtonTapped(_ sender: UIButton) {
        if let singupVC = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as? SignupViewController {
            UIApplication.shared.windows.first?.rootViewController = singupVC
            //            singupVC.modalPresentationStyle = .fullScreen
//            self.present(singupVC, animated: true)
        }
    }
    
}

