//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

extension BusinessesViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate,  UIScrollViewDelegate{
    
    //function to filter name
    func filterContentForSearchText(searchText: String, scope: String = "All") {
       filteredNames = restaurantNames.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        
        tableView.reloadData()
    }
    
    //adding the search controller
    let searchController = UISearchController(searchResultsController: nil)

    
    //the names of the restaurants that match the search string
    var filteredNames = [String]()
    
    //all the restaurant names
    var restaurantNames = [String]()
    
    //the array of businesses to show when searching
    var businessesToShow = [Business]()
    
    
    @IBOutlet weak var tableView: UITableView!
    var businesses: [Business]!
    
   
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting up the search bar
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        
        navigationController!.navigationBar.barTintColor = UIColor.redColor()
        
    
        tableView.dataSource = self
        tableView.delegate = self
    
        
      
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        
        Business.searchWithTerm("Indian", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            for business in businesses {
                //append the name to the list of restaurant names
                self.restaurantNames.append(business.name!)
                //print(business)
            }
            print(self.restaurantNames)
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
       
       
        if searchController.active && searchController.searchBar.text != "" {
            return filteredNames.count
        }
        
        else{
            if let businesses = businesses {
                return businesses.count
            }
                //don't create the table if no data was fetched
            else{
                return 0
            }
        }
    }
    
    //to populate the cells with the desired values
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell",forIndexPath: indexPath) as! BusinessCell
        
        //if search is active
        if(searchController.active && searchController.searchBar.text != ""){
            businessesToShow.removeAll()
            
            //iterate over the businesses to get the businesses that we want to display
            
            for(var i = 0;  i < businesses.count; i++){
                let name = businesses[i].name!
                
                if(filteredNames.contains(name)){
                    businessesToShow.append(businesses[i])
                }
            }
            cell.business = businessesToShow[indexPath.row]
        }
        
        else{
            cell.business = businesses[indexPath.row]
        }
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
