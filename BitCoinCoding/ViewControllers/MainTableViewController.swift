//
//  MainViewController.swift
//  BitCoinCoding
//
//  Created by Mike Silvers on 5/29/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import UIKit
import RxSwift
import CoreLocation
import RxCoreLocation

class MainViewController: UITableViewController {
    
    // MARK: - Internal Variables
    private var locationManager     = CLLocationManager()
    private var showLocationRequest = true
    private var disposeBag = DisposeBag()
    private var currentLocation : CLLocationCoordinate2D?
    
    private var dataSource = [CurrentWeather]()
    
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
        
        // watch for the changes in location
        locationManager.rx
            .location
            .subscribe(onNext: { location in

                // when there is a location change, update the datasource
                if let loc = location {
                    self.currentLocation = loc.coordinate
                    self.reloadData()
                }
            })
            .disposed(by: disposeBag)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // check to make sure the location services were permitted
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse, showLocationRequest {
            performSegue(withIdentifier: "LocationRequestSegue", sender: nil)
        }
        
        // we are reloading the data even if there is no location permission - we will get the
        // weather information from the two cities and not your location if location is not permitted
        reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // we reset the showing location so they will be displayed the location request screen if
        // they display this view again.
        showLocationRequest = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Process the segue to the location manager
        if segue.identifier == "LocationRequestSegue",
            let lrvc = segue.destination as? LocationRequestViewController {
            
            // pass the location manager so it does not lose focus - if it loses focus
            // the user will not have time to see the Apple location prompt
            lrvc.locationManager = locationManager
            
        // process the segue providng the detail information when someone touches a cell
        } else if segue.identifier == "DetailSegue",
            let dtvc = segue.destination as? DetailViewController,
            let tbcell = sender as? MainTableViewCell {
            
            // pass the current weather object for information display
            dtvc.currentWeather = tbcell.currentWeather
            
        }
    }
    
    //MARK: - Button functions
    @IBAction func returnFromLocation(_ unwindSegue: UIStoryboardSegue) {
        // this is the unwind segue - we do not want to get in a loop of showing the
        // location manager when they hit cancel or if they deny
        showLocationRequest = false
    }

    //MARK: - TableDataSource functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: - TableViewDelegate functions
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath)
        
        if let cell = cell as? MainTableViewCell {
            
            // adding the weather information to the cell for use in the detasil
            cell.currentWeather = dataSource[indexPath.row]

            // setup the main label text
            let labeltext = "\(cell.currentWeather.name ?? "No City Name"): \(cell.currentWeather.main?.temp ?? -9999) degrees"
            cell.weatherDetailLabel.text = labeltext

            // setup the image - we are using a image cache to minimize netwoek traffic when retrieving the
            // images from the remote server
            if let ci = cell.currentWeather.weather?[0],
                let img = ci.icon {
                cell.weatherImage.cacheImage("https://openweathermap.org/img/w/\(img).png")
            } else {
                cell.weatherImage = nil
            }
        }
        
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // we are not going to show the cell selection
        // the segue handles the navigation to the detail page
        tableView.deselectRow(at: indexPath, animated: false)
    
    }
    
    //MARK: - Supporting functions
    /**
     Process the view model for current westher information
    */
    func reloadData() {
        
        // set the current location (if there is a current location)
        if let currentLocation = currentLocation {
            mainViewModel.currentLocation = currentLocation
        }
        
        // uses the data model to update the data source and update the table.
        mainViewModel.updateData { (data) in
            self.dataSource = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
