//
//  MainViewController.swift
//  BitCoinCoding
//
//  Created by Mike Silvers on 5/29/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation
import RxCoreLocation

class MainViewController: UIViewController {

    // MARK: - UI Variables
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Internal Variables
    private var locationManager     = CLLocationManager()
    private var showLocationRequest = true
    private var disposeBag = DisposeBag()
    private var currentLocation : CLLocationCoordinate2D?
    
    private var mainViewModel = MainViewModel()
    
    // MARK: - View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the location properties to conserve battery
        locationManager.activityType = .other
        locationManager.distanceFilter = 2414.02   // only check the distance every 1.5 miles
        
        
        // subscribe to the location manager when it changes
        locationManager.rx.didChangeAuthorization.subscribe(onNext: { (manager, status) in
            
            // if the status changed, start the updating
            if status == .authorizedWhenInUse {
                manager.startUpdatingLocation()
            }

        })
        .disposed(by: disposeBag)

        // start updating if they already allowed permission
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        
        // watch for the changes in location
        locationManager.rx.location.do(onNext: { location in
            if let loc = location {
                self.currentLocation = loc.coordinate
            }

        })
        
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
