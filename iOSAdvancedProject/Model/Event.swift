

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct Event: Decodable {
    @DocumentID var id: String?
    let name: String
    let description: String
    let organizer: String
    let lat: Double
    let lng: Double
    let imageURL: String
    var joinedUsers: [String]
    let timestamp: Timestamp
}
