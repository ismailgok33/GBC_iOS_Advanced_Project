
import UIKit

class SignupViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .quaternaryLabel
        self.title = "Signup"
    }
    
    
    // MARK: - Actions
    
    @IBAction func singupButtonTapped(_ sender: UIButton) {
        let email = emailTextField.text ?? ""
        let firstname = firstnameTextField.text ?? ""
        let lastname = lastnameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        AuthViewModel.shared.register(withEmail: email, password: password, firstname: firstname, lastname: lastname)
    }
    
    @IBAction func switchToSigninButtonTapped(_ sender: UIButton) {
        if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            UIApplication.shared.windows.first?.rootViewController = loginVC
        }
        
    }
    
    
    
}
