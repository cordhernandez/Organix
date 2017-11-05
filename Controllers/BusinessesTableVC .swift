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

class BusinessesTableVC: UITableViewController {

    var businesses: [Businesses] = []

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
    }
}

//MARK: - Table View DataSource
extension BusinessesTableVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return businesses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: BusinessesTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellKeys.businessesCellKey, for: indexPath) as? BusinessesTableViewCell else {
            
            LOG.error("Failed to dequeue cell for Businesses Table View Controller")
            return UITableViewCell()
        }
        
        let row = indexPath.row
        let business = businesses[row]
        
        goLoadImage(into: cell, withBusiness: business.imageURL)
        cell.businessName.text = business.name
        cell.businessPrice.text = business.price
        cell.businessRating.text = String(business.rating)
        cell.businessPhoneNumber.text = business.phone
//        cell.businessDistance.text = String(business.distance)
        cell.businessDistance.text = business.isClosed ? "Closed" : "Open"
        
        return cell
    }
}

//MARK: - Table View Delegate
extension BusinessesTableVC {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let rowHeight: CGFloat = 190
        
        return rowHeight
    }

}

//MARK: - Load Data
extension BusinessesTableVC {
    
    func setupRefreshControl() {
        
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.black
        refreshControl?.tintColor = UIColor.white
        
        refreshControl?.addTarget(self, action: #selector(self.loadBusinesses), for: .valueChanged)
        
    }
    
    @objc func loadBusinesses() {
        
        SearchBusinesses.searchForBusinessesByCity(withCity: "LosAngeles", callback: self.populateBusinesses)
    }
    
    private func populateBusinesses(businesses: [Businesses]) {
        
        self.businesses = businesses
        
        self.main.addOperation {
            
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    private func goLoadImage(into cell: BusinessesTableViewCell, withBusiness url: URL) {
        
        let fade = KingfisherOptionsInfoItem.transition(.fade(0.5))
        let scale = KingfisherOptionsInfoItem.scaleFactor(UIScreen.main.scale * 2)
        let options: KingfisherOptionsInfo = [fade, scale]
        
        cell.businessImage.kf.setImage(with: url, placeholder: nil, options: options, progressBlock: nil, completionHandler: nil)
    }
    
}

