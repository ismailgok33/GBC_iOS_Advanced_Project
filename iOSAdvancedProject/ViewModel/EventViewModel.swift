//
//  EventViewModel.swift
//  iOSAdvancedProject
//
//  Created by Ismail Gok on 2022-05-23.
//

import Foundation

class EventViewModel {
    
    static let shared = EventViewModel()
    
    @Published var events = [Event]()
    
    func fetchEvents() {
        COLLECTION_EVENTS.getDocuments { snapshot, _ in
            guard let document = snapshot?.documents else { return }
            self.events = document.compactMap({ try? $0.data(as: Event.self) })
            
        }
    }
}
