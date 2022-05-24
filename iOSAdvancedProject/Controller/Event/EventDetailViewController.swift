//
//  EventDetailViewController.swift
//  iOSAdvancedProject
//
//  Created by Ismail Gok on 2022-05-23.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var joinEventButton: UIButton!
    
    
    // MARK: - Properties
    var event: Event?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchEventStatus()
    }
    
    // MARK: - Helpers
    
    private func setEventButtonStyle(title: String, color: UIColor) {
        self.joinEventButton.setTitle(title, for: .normal)
        self.joinEventButton.tintColor = color
    }
    
    private func toggleEventButtonStyle() {
        if self.joinEventButton.titleLabel?.text == JOIN_BUTTON_TEXT {
            setEventButtonStyle(title: LEAVE_BUTTON_TEXT, color: .leaveButtonColor)
        }
        else if self.joinEventButton.titleLabel?.text == LEAVE_BUTTON_TEXT {
            setEventButtonStyle(title: JOIN_BUTTON_TEXT, color: .joinButtonColor)
        }
    }
    
    private func fetchEventStatus() {
        guard let currentUser = AuthViewModel.shared.currentUser, let event = event else { return }
        
        // Check if the current event is in the joinedEvent list for the user
        if currentUser.joinedEvents.filter({ $0 == event.id }).count > 0 {
            setEventButtonStyle(title: LEAVE_BUTTON_TEXT, color: .leaveButtonColor)
        }
        else {
            setEventButtonStyle(title: JOIN_BUTTON_TEXT, color: .joinButtonColor)
        }
    }
    
    
    // MARK: - Selectors
    
    
    // MARK: - Actions
    
    @IBAction func joinEventButtonTapped(_ sender: UIButton) {
        guard let event = event, let eventID = event.id else {
            print(#function, "Event cannot be found!")
            return
        }

        if sender.titleLabel?.text == JOIN_BUTTON_TEXT {
            UserViewModel.shared.joinEvent(eventID: eventID)
            toggleEventButtonStyle()
        }
        else if sender.titleLabel?.text == LEAVE_BUTTON_TEXT {
            UserViewModel.shared.leaveEvent(eventID: eventID)
            toggleEventButtonStyle()
        }
        else {
            print(#function, "Button name cannot be recognized!")
        }
    }
    

}
