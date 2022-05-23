//
//  EventTableViewCell.swift
//  iOSAdvancedProject
//
//  Created by Ismail Gok on 2022-05-23.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "eventCell"
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var numberOfPeopleGoingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    static func nib() -> UINib {
        return UINib(nibName: "EventTableViewCell", bundle: nil)
    }
    
    func configureUI(event: Event) {
        self.nameLabel.text = event.name
        self.descriptionLabel.text = event.description
        self.numberOfPeopleGoingLabel.text = "\(event.joinedUsers.count)"
    }
    
}
