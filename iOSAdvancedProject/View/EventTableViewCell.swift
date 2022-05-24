

import UIKit
import Kingfisher
import FirebaseStorage

class EventTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "eventCell"
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberOfPeopleGoingLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventDate: UILabel!
    
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
        self.eventDate.text = event.timestamp.dateValue().formatted()
        self.numberOfPeopleGoingLabel.text = "\(event.joinedUsers.count)"
        
        let ref = Storage.storage().reference(withPath: "/event_images/\(event.imageURL)")
        ref.downloadURL { url, _ in
            self.eventImage.kf.setImage(with: url)
        }
        
    }
    
}
