//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit



class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate,  UIScrollViewDelegate, UISearchControllerDelegate {
    //adding the search controller
    let searchController = UISearchController(searchResultsController: nil)
    
    //the names of the restaurants that match the search string
    var filteredNames = [String]()
    
    
    @IBOutlet weak var tableView: UITableView!
    var businesses: [Business]!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        
        navigationController!.navigationBar.barTintColor = UIColor.redColor()
        
    
        tableView.dataSource = self
        tableView.delegate = self
        searchController.delegate = self
      
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        
        Business.searchWithTerm("Indian", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            for business in businesses {
                //append the name to the list of restaurant names
                //self.restaurantNames.append(business.name!)
                print(business)
            }
            
        })
        
        /* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
        self.businesses = businesses
        
        for business in businesses {
        print(business.name!)
        print(business.address!)
        }
        }
        */
    }
    
    
    
    
    

    
    //the number of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if let businesses = businesses {
            return businesses.count
        }
            //don't create the table if no data was fetched
        else{
            return 0
        }
    }
    
    //to populate the cells with the desired values
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell",forIndexPath: indexPath) as! BusinessCell
        
            cell.business = businesses[indexPath.row]
       
        return cell
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
    }
    
    //implementing the delegate method
    func filtersViewController(filterViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        let categories = filters["categories"] as? [String]
        Business.searchWithTerm("Restaurants", sort: nil, categories: categories, deals: nil) {(businesses: [Business]!,error:NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
        
        
        
        
        
    }
}
