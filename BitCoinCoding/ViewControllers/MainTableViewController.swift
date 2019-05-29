//
//  MainViewController.swift
//  BitCoinCoding
//
//  Created by Mike Silvers on 5/29/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {

    // MARK: - UI Variables
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Internal Variables
    private var locationManager     = CLLocationManager()
    private var showLocationRequest = true

    //MARK: - Variables
    
    // MARK: - View functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // check to make sure the location services were permitted
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse, showLocationRequest {
            performSegue(withIdentifier: "LocationRequestSegue", sender: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // we reset the showing location so they will be displayed the location request screen if
        // they come here again.
        showLocationRequest = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Process the segue to the location manager
        if segue.identifier == "LocationRequestSegue",
            let lrvc = segue.destination as? LocationRequestViewController {
            
            // pass the location manager so it does not lose focus - if it loses focus
            // the user will not have time to see the location prompt
            
            lrvc.locationManager = locationManager
            
        }
    }
    
    //MARK: - Button finctions
    @IBAction func returnFromLocation(_ unwindSegue: UIStoryboardSegue) {
        // this is the unwind segue - we do not want to get in a loop of showing the
        // location manager when they hit cancel or if they deny
        showLocationRequest = false
    }

    

    
}
