//
//  UserViewModel.swift
//  iOSAdvancedProject
//
//  Created by Ismail Gok on 2022-05-23.
//

import Foundation
import SwiftUI

class UserViewModel {
    
    static let shared = UserViewModel()
    
    @Published var joinedEvents = [Event]()
    
    func fetchJoinedEvents() {
        guard let user = AuthViewModel.shared.currentUser else { return }
        
        self.joinedEvents.removeAll()
        
        for eventID in user.joinedEvents {
            COLLECTION_EVENTS.document(eventID).getDocument { snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    print(#function, error!.localizedDescription)
                    return
                }
                
                do {
                    let event = try snapshot.data(as: Event.self)
                    self.joinedEvents.append(event)
                }
                catch let error {
                    print(#function, error.localizedDescription)
                }
            }
        }
    }
    
    func joinEvent(eventID: String) {
        
        guard let user = AuthViewModel.shared.currentUser else { return }
        let uid = "\(user.id ?? "")"
        
        // Step-1: Update "events" document
        // Fetch the event data from Firebase
        COLLECTION_EVENTS.document(eventID).getDocument { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print(#function, error!.localizedDescription)
                return
            }
            
            do {
                let event = try snapshot.data(as: Event.self)
                
                // Add current user to joinedUsers array
                var joinedUsers = event.joinedUsers
                joinedUsers.append(uid)
                
                // Update the joinedUsers Array and set update Firebase
                COLLECTION_EVENTS.document(eventID).setData(["joinedUsers": joinedUsers], merge: true)
            }
            catch let error {
                print(#function, error.localizedDescription)
            }
        }
        
        // Step-2: Update "users" document
        // Add current event to joinedEvents array
        var joinedEvents = user.joinedEvents
        joinedEvents.append(eventID)
        
        // Update the joinedEvents Array and set update Firebase
        COLLECTION_USERS.document(uid).setData(["joinedEvents": joinedEvents], merge: true)
        
        // Update User model
        AuthViewModel.shared.fetchUser()
    }
    
    func leaveEvent(eventID: String) {
        
        guard let user = AuthViewModel.shared.currentUser else { return }
        let uid = "\(user.id ?? "")"
        
        // Step-1: Update "events" document
        // Fetch the event data from Firebase
        COLLECTION_EVENTS.document(eventID).getDocument { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print(#function, error!.localizedDescription)
                return
            }
            
            do {
                let event = try snapshot.data(as: Event.self)
                
                // Add current user to joinedUsers array
                var joinedUsers = event.joinedUsers
                joinedUsers.removeAll(where: { $0 == uid })
                
                // Update the joinedUsers Array and set update Firebase
                COLLECTION_EVENTS.document(eventID).setData(["joinedUsers": joinedUsers], merge: true)
            }
            catch let error {
                print(#function, error.localizedDescription)
            }
        }
        
        // Step-2: Update "users" document
        // Add current event to joinedEvents array
        var joinedEvents = user.joinedEvents
        joinedEvents.removeAll(where: { $0 == eventID })
        
        // Update the joinedEvents Array and set update Firebase
        COLLECTION_USERS.document(uid).setData(["joinedEvents": joinedEvents], merge: true)
        
        // Update User model
        AuthViewModel.shared.fetchUser()
    }
    
   
}
