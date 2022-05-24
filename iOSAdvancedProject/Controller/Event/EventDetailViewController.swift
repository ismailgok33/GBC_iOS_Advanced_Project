
import UIKit
import MapKit
import CoreLocation
import Kingfisher
import FirebaseStorage

class EventDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var joinEventButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var location: UILabel!
    //    @IBOutlet weak var organizer: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: - Properties
    var event: Event?
    private let geocoder = CLGeocoder()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchEventStatus()
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        self.title = event?.name
        if let event = event {
            let ref = Storage.storage().reference(withPath: "/event_images/\(event.imageURL)")
            ref.downloadURL { url, _ in
                self.imageView.kf.setImage(with: url)
            }
            self.eventDescription.text = event.description
            self.eventDate.text = event.timestamp.dateValue().formatted()
//            self.organizer.text = event.organizer
            
            mapViewFunction(lat: event.lat, lng: event.lng)
            ReverseGeoCode(lat: event.lat, lng: event.lng)
            
        }
    }
    
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
    
    private func mapViewFunction(lat: Double, lng: Double) {
        
        let centerOfMapCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng )
        
        let zoomLevel = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        let visibleRegion = MKCoordinateRegion(center: centerOfMapCoordinate , span: zoomLevel)
        
        self.mapView.setRegion(visibleRegion, animated: true)
        
        let mapMarker = MKPointAnnotation()
        mapMarker.coordinate = centerOfMapCoordinate
        mapMarker.title = "Event Is Here!"
        self.mapView.addAnnotation(mapMarker)
    }
    
    func ReverseGeoCode(lat: Double, lng: Double) {
        
        let locationToFind = CLLocation(latitude: lat, longitude: lng)
        geocoder.reverseGeocodeLocation(locationToFind) {
            (resultsList, error) in
            
            if let errors = error {
                print("Error during the reverse geocoding: \(errors.localizedDescription)")
                return
            }
            else {
                print("Matching location found: \(resultsList!.count)")
                let locationResult:CLPlacemark = resultsList!.first!
                print(locationResult)
                
                print("Getting location data:")
                let name = locationResult.name ?? "Not available"
                let street = locationResult.thoroughfare ?? "Not available"
                let city = locationResult.locality ?? "Not available"
                let postalCode = locationResult.postalCode ?? "Not available"
                
                let output = "\(name), \(street), \(city), \(postalCode)"
                print(output)
                self.location.text = "\(output)"
                
            }
        }
    }
    
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
