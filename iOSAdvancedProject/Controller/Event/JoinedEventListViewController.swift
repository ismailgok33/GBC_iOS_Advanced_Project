//
//  JoinedEventListViewController.swift
//  iOSAdvancedProject
//
//  Created by Ismail Gok on 2022-05-23.
//

import UIKit
import Combine

class JoinedEventListViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var joinedEvents = [Event]()
    private var cancellables: Set<AnyCancellable> = []
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(EventTableViewCell.nib(), forCellReuseIdentifier: EventTableViewCell.reuseIdentifier)
        
        configureUI()
        
        receiveChanges()
        
//        UserViewModel.shared.fetchJoinedEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserViewModel.shared.fetchJoinedEvents()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonTapped))
    }
    
    private func goToLoginScreen() {
        if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            UIApplication.shared.windows.first?.rootViewController = loginVC
        }
    }
    
    private func receiveChanges() {
        UserViewModel.shared.$joinedEvents
            .receive(on: RunLoop.main)
            .sink { updatedData in
                self.joinedEvents = updatedData
                self.joinedEvents.sort(by: { $0.timestamp.seconds > $1.timestamp.seconds })
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Selectors
    @objc private func logoutButtonTapped() {
        
        // Logout from Firebase
        AuthViewModel.shared.signOut()
        
        // Show Login Screen
        goToLoginScreen()
    }
    
    
    // MARK: - Actions
    

}

extension JoinedEventListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return joinedEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.reuseIdentifier, for: indexPath) as! EventTableViewCell
        
        cell.configureUI(event: joinedEvents[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // go to Event Details Screen
        if let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailViewController") as? EventDetailViewController {
            detailVC.event = joinedEvents[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
}
