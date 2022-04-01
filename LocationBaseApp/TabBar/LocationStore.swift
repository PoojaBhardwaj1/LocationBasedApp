//
//  LocationStore.swift
//  LocationBaseApp
//
//  Created by Pooja on 01/04/22.
//

import Foundation
import UIKit
import CoreData


class LocationStorage {
    
    static let sharedInstace = LocationStorage()
    
    
    func storeLocations(date : Date , time: String , placeName : String){
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // 1
        let managedContext =
        appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
        NSEntityDescription.entity(forEntityName: "LocationList",
                                   in: managedContext)!
        
        let locationName = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        locationName.setValue(placeName, forKeyPath: "placeName")
        locationName.setValue(date, forKey: "date")
        locationName.setValue(time, forKey: "time")
        
        // 4
        do {
            try managedContext.save()
            //people.append(person)
            print("Record saved")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}

