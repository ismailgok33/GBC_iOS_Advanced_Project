//
//  ViewController.swift
//  iOSAdvancedProject
//
//  Created by Ismail Gok on 2022-05-21.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .quaternaryLabel
        self.title = "Login"
    }
    
    
    // MARK: - Actions
    @IBAction func LoginButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func SwitchToSignupButtonTapped(_ sender: UIButton) {
        if let singupVC = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as? SignupViewController {
            singupVC.modalPresentationStyle = .fullScreen
            self.present(singupVC, animated: true)
        }
    }
    
}

