//
//  MapView.swift
//  LocationBaseApp
//
//  Created by Pooja on 31/03/22.
//

import UIKit
import MapKit

class MapView: UIViewController  , GetLocationDelegate{

    
    var isStarted = true
    @IBOutlet weak var mapVw: MKMapView!
    
    @IBOutlet weak var startStopBtn: UIButton!
    var addressStr = String()
    let locationManager = CLLocationManager()

    
    //MARK: - Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        getLocationInstance.initLocationManager()
        getLocationInstance.delegate = self
        
        isStarted = true
        self.mapVw.delegate = self
        self.mapVw.mapType = .standard
        self.mapVw.isZoomEnabled = true
        self.mapVw.isScrollEnabled = true
        self.mapVw.showsUserLocation = true
        self.mapVw.userTrackingMode = .follow

        if let coor = self.mapVw.userLocation.location?.coordinate{
            self.mapVw.setCenter(coor, animated: true)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(newLocationAdded(_:)), name: .newLocationSaved, object: nil)
    }
    
    
    @objc func newLocationAdded(_ notification: Notification) {
      guard let location = notification.userInfo?["location"] as? Location else {
        return
      }
      
      let annotation = annotationForLocation(location)
      mapVw.addAnnotation(annotation)
    }
    
    
    func annotationForLocation(_ location: Location) -> MKAnnotation {
      let annotation = MKPointAnnotation()
      annotation.title = location.dateString
      annotation.coordinate = location.coordinates
      return annotation
    }
    
    //MARK: - IBAction functions
    
    @IBAction func startStopTracking(_ sender: Any) {
        
        if isStarted{
            self.startStopBtn.setTitle("Start Tracking", for: .normal)
            self.startStopBtn.backgroundColor = UIColor.blue
            getLocationInstance.stopLocationTracking()
            isStarted = false
        }else{
            self.startStopBtn.setTitle("Stop Tracking", for: .normal)
            self.startStopBtn.backgroundColor = UIColor.red
            getLocationInstance.startLocationTracking()
            isStarted = true
        }
    }
    
    //MARK: - GetLocation delegate functions
    
    func gotLocationString(str: String , locValue:CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        
        annotation.title = str
        annotation.subtitle = "current location"
        self.mapVw.addAnnotation(annotation)
    }
    
    func locationUpdated(lat: Double, longi: Double , locValues:CLLocationCoordinate2D ) {
        mapVw.mapType = MKMapType.standard

        let span = MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)  //MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: locValues, span: span)
        mapVw.setRegion(region, animated: true)
    }
}



extension  MapView : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { print("no mkpointannotaions"); return nil }

        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
           // pinView!.pinTintColor = UIColor.black
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        
        
        //print("tapped on pin ")
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let doSomething = view.annotation?.title! {
               print("do something")
            }
        }
      }
    }

extension Notification.Name {
  static let newLocationSaved = Notification.Name("newLocationSaved")
}
