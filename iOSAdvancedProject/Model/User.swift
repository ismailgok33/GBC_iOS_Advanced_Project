
import Foundation
import FirebaseFirestoreSwift

struct User: Decodable {
    @DocumentID var id: String?
    let email: String
    let firstname: String
    let lastname: String
    var joinedEvents: [String]
}
