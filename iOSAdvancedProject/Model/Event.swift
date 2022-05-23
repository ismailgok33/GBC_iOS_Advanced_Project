//
//  Event.swift
//  iOSAdvancedProject
//
//  Created by Ismail Gok on 2022-05-23.
//

import Foundation
import FirebaseFirestoreSwift

struct Event: Decodable {
    @DocumentID var id: String?
    let name: String
    let description: String
    var joinedUsers: [String]
}
