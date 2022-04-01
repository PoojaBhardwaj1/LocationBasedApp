//
//  CurrentDistanceVC.swift
//  LocationBaseApp
//
//  Created by Pooja on 31/03/22.
//

import UIKit

class CurrentDistanceVC: UIViewController , GetLocationDelegate {
    
    @IBOutlet weak var distanceLbl: UILabel!
    
    //MARK: - Viewcontroller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        getLocationInstance.delegate = self
    }
 
    //MARK: - Get Location delegates
    
    func totalDistanceTravelled(value: Double) {
        self.distanceLbl.text = String(format: "\n %.2f mt", value)   //"\(getLocationInstance.totalDistance)"

    }
}
