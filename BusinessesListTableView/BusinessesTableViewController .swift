//
//  ViewController.swift
//  Organix
//
//  Created by Cordero Hernandez on 10/31/17.
//  Copyright © 2017 Cordero Hernandez. All rights reserved.
//

import Archeota
import CoreLocation
import Kingfisher
import UIKit

class BusinessesTableViewController: UITableViewController {
    
    var filteredBusinesses: [Businesses] = []
    var businesses: [Businesses] = []
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    let main = OperationQueue.main
    let async: OperationQueue = {
        
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 3
        
        return operationQueue
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadBusinesses()
        setupRefreshControl()
        setupSearchBar()
    }
}

//MARK: - Table View DataSource
extension BusinessesTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            
            return filteredBusinesses.count
        }
        else {
            
            return businesses.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: BusinessesTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellKeys.businesses, for: indexPath) as? BusinessesTableViewCell else {
            
            LOG.error("Failed to dequeue cell for Businesses Table View Controller")
            return UITableViewCell()
        }
        
        let row = indexPath.row
        var business: Businesses
        
        if isFiltering() {
            business = filteredBusinesses[row]
        }
        else {
            business = businesses[row]
        }
        
        goLoadImage(into: cell, withBusiness: business.imageURL)
        cell.businessName.text = business.name
        cell.businessPrice.text = business.price
        cell.businessRating.text = String(business.rating)
        cell.businessPhoneNumber.text = business.phone
        cell.businessDistance.text = business.isClosed ? "Closed" : "Open"
        
        return cell
    }
}

//MARK: - Table View Delegate
extension BusinessesTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let rowHeight: CGFloat = 190
        
        return rowHeight
    }
    
}

//MARK - Search
extension BusinessesTableViewController: UISearchResultsUpdating {
    
    func isFiltering() -> Bool {
        
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func setupSearchBar() {
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Enter City or Zip Code"
        
        definesPresentationContext = false
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text == "" {
            filteredBusinesses = businesses
        }
        else {
            
            guard let modifiedText = searchController.searchBar.text?.replacingOccurrences(of: " ", with: "") else { return }
            print("THIS IS THE MODIFIED TEXT: \(modifiedText)")
            loadBusinessesFrom(theCity: modifiedText)
        }
        
        self.main.addOperation {
            
            self.tableView.reloadData()
        }
    }
}

//MARK: - Load Data
extension BusinessesTableViewController {
    
    func setupRefreshControl() {
        
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.black
        refreshControl?.tintColor = UIColor.white
        
        refreshControl?.addTarget(self, action: #selector(self.loadBusinesses), for: .valueChanged)
        
    }
    
    func loadBusinessesFrom(theCity city: String) {
        
        startSpinningIndicator()
        SearchBusinesses.searchForBusinessesByCity(withCity: city, callback: self.populateBusinesses)
    }
    
    @objc func loadBusinesses() {
        
        startSpinningIndicator()
        SearchBusinesses.searchForBusinessesByCity(withCity: "LosAngeles", callback: self.populateBusinesses)
    }
    
    private func populateBusinesses(businesses: [Businesses]) {
        
        self.businesses = businesses
        
        self.main.addOperation {
            
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            self.stopSpinningIndicator()
        }
        
        if self.businesses.isEmpty {
            //Make note that businesses are empty
        }
    }
    
    private func goLoadImage(into cell: BusinessesTableViewCell, withBusiness url: URL) {
        
        let fade = KingfisherOptionsInfoItem.transition(.fade(0.5))
        let scale = KingfisherOptionsInfoItem.scaleFactor(UIScreen.main.scale * 2)
        let options: KingfisherOptionsInfo = [fade, scale]
        
        cell.businessImage.kf.setImage(with: url, placeholder: nil, options: options, progressBlock: nil, completionHandler: nil)
    }
}

//MARK: Segues
extension BusinessesTableViewController {
    
    @IBAction func didTapMapButton(_ sender: Any) {
        
        goToMapView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? UINavigationController {
            
            let businessesMapViewController = destination.topViewController as? BusinessesMapViewController
            businessesMapViewController?.businesses = self.businesses
        }
    }
    
    func goToMapView() {
        
        performSegue(withIdentifier: SegueKeys.mapView, sender: nil)
    }

}































