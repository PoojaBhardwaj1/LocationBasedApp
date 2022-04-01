//
//  DistanceListVC.swift
//  LocationBaseApp
//
//  Created by Pooja on 31/03/22.
//

import UIKit
import CoreData

class DistanceListVC: UIViewController {

    //MARK: - Viewcontroller lifecycle
    var locationArray = [LocationList]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: "LocationListCellTableViewCell", bundle: nil), forCellReuseIdentifier: "locationList")
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 100
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getSavedLocations()
    }
    
    func getSavedLocations(){
        //1
          guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "LocationList")
          
          //3
          do {
           
               locationArray = try managedContext.fetch(fetchRequest) as! [LocationList]
               print("Stored data = \(locationArray)")
              self.tableView.reloadData()
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }
        
    }
    
}


extension DistanceListVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "locationList") as! LocationListCellTableViewCell
        
        let location = locationArray[indexPath.row]
        cell.placeName.text = location.placeName
        cell.dateTimeLbl.text = "\(location.date!) \(location.time!)"
        return cell
    }
    
}
