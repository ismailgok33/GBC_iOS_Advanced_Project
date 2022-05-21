//
//  AuthViewModel.swift
//  iOSAdvancedProject
//
//  Created by Ismail Gok on 2022-05-21.
//

import Foundation
import Firebase

class AuthViewModel {
    var userSession: FirebaseAuth.User?
    var currentUser: User?
    
    static let shared = AuthViewModel()
    
    init() {
        userSession = Auth.auth().currentUser
        
    }
    
    func login(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard let user = result?.user, error == nil else {
                print(#function, error!.localizedDescription)
                return
            }
            
            self.userSession = user
            self.fetchUser()
        }
    }
    
    func register(withEmail email: String, password: String, firstname: String, lastname: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard let user = result?.user, error == nil else {
                print(#function, error!.localizedDescription)
                return
            }
            
            self.userSession = user
            
            // Upload User to Firestore DB
            let data = ["email": email, "firstname": firstname, "lastname": lastname, "uid": user.uid]
            COLLECTION_USERS.document(user.uid).setData(data) { _ in
                print("DEBUG: User is uploaded to DB successfully")
                self.userSession = user
                self.fetchUser()
            }
        }
    }
    
    func fetchUser() {
        guard let uid = userSession?.uid else { return }
        
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print(#function, error!.localizedDescription)
                return
            }
            
            do {
                let user = try snapshot.data(as: User.self)
                self.currentUser = user
            }
            catch let error {
                print(#function, error.localizedDescription)
            }

        }
    }
    
}
