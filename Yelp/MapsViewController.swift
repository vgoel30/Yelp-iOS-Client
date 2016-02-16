//
//  MapsViewController.swift
//  Yelp
//
//  Created by Varun Goel on 2/14/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapsViewController: UIViewController {
    
    var latitude: Double = 0
    var longitude: Double = 0
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    //function to go to a particular location given the longitude and latitude
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.009, 0.009)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let centerLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        goToLocation(centerLocation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation*/
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let cell = sender as! UITableViewCell
//        
//        let indexPath = self.tableView.indexPathForCell(cell)
//        print(indexPath)
//    }


}
