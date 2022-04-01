//
//  File.swift
//  LocationBaseApp
//
//  Created by Pooja on 31/03/22.
//

import Foundation
import UIKit
import CoreLocation


@objc protocol GetLocationDelegate{
    
    @objc optional func locationUpdated(lat : Double , longi:Double , locValues:CLLocationCoordinate2D)
    @objc optional func gotLocationString(str : String , locValue : CLLocationCoordinate2D)
    @objc optional func totalDistanceTravelled(value : Double)
}

class GetLocation : NSObject , CLLocationManagerDelegate{
    
    
    var totalDistance = CLLocationDistance()

    
    var oldLocationArray = [CLLocation]()

    static let sharedInstance = GetLocation()
    
    weak var delegate: GetLocationDelegate?

    var latitude =  Double()
    var longitude = Double()
    
    var locationString = String()
    
    let locationManager = CLLocationManager()
    
    func initLocationManager(){
        self.locationManager.requestAlwaysAuthorization()

//        mapVw.delegate = self
//        mapVw.mapType = .standard
//        mapVw.isZoomEnabled = true
//        mapVw.isScrollEnabled = true
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.distanceFilter = 10
            locationManager.allowsBackgroundLocationUpdates = true

            locationManager.startUpdatingLocation()
        }
    }
    
    func startLocationTracking(){
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationTracking(){
        locationManager.stopUpdatingLocation()
    }

    //MARK: - Location delegate functions
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate

//        mapVw.mapType = MKMapType.standard
//
//        let span = MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)  //MKCoordinateSpanMake(0.05, 0.05)
//        let region = MKCoordinateRegion(center: locValue, span: span)
//        mapVw.setRegion(region, animated: true)
//
        let locationLat = "\(locValue.latitude)"
        let locationLong = "\(locValue.longitude)"
        
        self.delegate?.locationUpdated?(lat: locValue.latitude, longi: locValue.longitude , locValues: locValue)
        
        self.getAddressFromLatLon(pdblLatitude: locationLat, withLongitude: locationLong , locationValue: locValue)
        
        var newLocation: CLLocation = locations[0] as CLLocation

        if oldLocationArray.count > 0{
            var oldLocation = oldLocationArray.last
            oldLocationArray.append(newLocation)

            let distanceTraveled = newLocation.distance(from: oldLocation!)

            totalDistance += distanceTraveled
            print("total distance \(totalDistance)")
            
            self.delegate?.totalDistanceTravelled?(value: totalDistance)
        }else{
            oldLocationArray.append(newLocation)
            totalDistance = 0
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        
    }
    
    
    func newVisitReceived(_ visit: CLVisit, description: String) {
        print(visit.arrivalDate)
        print(visit.coordinate)
        print(visit.departureDate)
       // let location = Location(visit: visit, descriptionString: description)

        // Save location to disk
      }
    
    //MARK: - Location convertion functions
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String , locationValue : CLLocationCoordinate2D){
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            //21.228124
            let lon: Double = Double("\(pdblLongitude)")!
            //72.833770
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon

            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)

            ceo.reverseGeocodeLocation(loc, completionHandler:
                                        { [self](placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                
                if let pm = placemarks as [CLPlacemark]?{
                    
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        print(pm.country)
                        print(pm.locality)
                        print(pm.subLocality)
                        print(pm.thoroughfare)
                        print(pm.postalCode)
                        print(pm.subThoroughfare)
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                        
                        print(addressString)
                        self.locationString = addressString
                        
                        let currentDate = Date()
                        let location = Location(locationValue, date: currentDate, descriptionString: "\(addressString)")

                        
                        // set notification body
                        let content = UNMutableNotificationContent()
                        content.title = "New Location entry"
                        content.body = location.description
                        content.sound = UNNotificationSound.default
                        
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                        let request = UNNotificationRequest(identifier: location.dateString, content: content, trigger: trigger)
                        notiCenter.add(request, withCompletionHandler: nil)
                        
                        // ------------------------------------
                      //  NotificationCenter.default.post(name: .newLocationSaved, object: self, userInfo: ["location": location])

                        
                        
                        LocationStorage.sharedInstace.storeLocations(date: currentDate, time: getTime(), placeName: addressString)
                        
                        self.delegate?.gotLocationString?(str: addressString , locValue: locationValue)
                    
                    
                    
                }
                
                    let pm = placemarks! as [CLPlacemark]

                   
//                        let annotation = MKPointAnnotation()
//                        annotation.coordinate = locationValue
//                        annotation.title = addressString
//                        annotation.subtitle = "current location"
//                        self.mapVw.addAnnotation(annotation)
                  }
            })
   }
    
    
    
    func getTime()-> String{
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        return "\(hour):\(minutes)"
    }
    
}

