
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
        
        // Display an error if there is any
        AuthViewModel.shared.$error
            .receive(on: RunLoop.main)
            .sink{ updatedData in
                if let error = updatedData {
                    self.showErrorAlert()
                }
            }
            .store(in: &cancellables)
    }
    
    private func goToEventListScreen() {
        if let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController {
            UIApplication.shared.windows.first?.rootViewController = tabBarVC
        }
    }
    
    private func showErrorAlert() {
        
        let alertVC = UIAlertController(title: "Error", message: "Wrong email and/or password", preferredStyle: .alert)
        let alertButton = UIAlertAction(title: "OK", style: .default)
        
        alertVC.addAction(alertButton)
        self.present(alertVC, animated: true)
        
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
        }
    }
    
}

