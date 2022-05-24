
import Foundation
import Firebase

class AuthViewModel {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var error: String?
    
    static let shared = AuthViewModel()
    
    init() {
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    func login(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard let user = result?.user, error == nil else {
                print(#function, error!.localizedDescription)
                self.error = error!.localizedDescription
                return
            }
            
            self.userSession = user
            self.error = nil
            self.fetchUser()
        }
    }
    
    func signOut() {
        self.userSession = nil
        try? Auth.auth().signOut()
    }
    
    func register(withEmail email: String, password: String, firstname: String, lastname: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard let user = result?.user, error == nil else {
                print(#function, error!.localizedDescription)
                return
            }
            
            self.userSession = user
            
            // Upload User to Firestore DB
            let data = ["email": email, "firstname": firstname, "lastname": lastname, "joinedEvents" : [String](), "uid": user.uid] as [String : Any]
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
