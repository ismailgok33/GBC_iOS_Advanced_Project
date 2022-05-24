//
//  EventListViewController.swift
//  iOSAdvancedProject
//
//  Created by Ismail Gok on 2022-05-23.
//

import UIKit
import Combine

class EventListViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var events = [Event]()
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(EventTableViewCell.nib(), forCellReuseIdentifier: EventTableViewCell.reuseIdentifier)
        
        configureUI()
        
        receiveChanges()
        
//        EventViewModel.shared.fetchEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        EventViewModel.shared.fetchEvents()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonTapped))
        
//        self.tableView.rowHeight = UITableView.automaticDimension
//        self.tableView.estimatedRowHeight = 150
    }
    
    private func receiveChanges() {
        EventViewModel.shared.$events
            .receive(on: RunLoop.main)
            .sink { updatedData in
                self.events = updatedData
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        AuthViewModel.shared.$userSession
            .receive(on: RunLoop.main)
            .sink { updatedData in
                if updatedData == nil {
                    self.goToLoginScreen()
                }
            }
            .store(in: &cancellables)
    }
    
    private func goToLoginScreen() {
        if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            UIApplication.shared.windows.first?.rootViewController = loginVC
        }
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

// MARK: - UITableView Delegate & DataSource

extension EventListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.reuseIdentifier, for: indexPath) as! EventTableViewCell
        
        cell.configureUI(event: events[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
        
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // go to Event Details Screen
        if let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailViewController") as? EventDetailViewController {
            detailVC.event = events[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }

}
