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
        
        reloadData()
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
            
        } else if segue.identifier == "DetailSegue",
            let dtvc = segue.destination as? DetailViewController,
            let tbcell = sender as? MainTableViewCell {
            
            dtvc.currentWeather = tbcell.currentWeather
            
        }
    }
    
    //MARK: - Button finctions
    @IBAction func returnFromLocation(_ unwindSegue: UIStoryboardSegue) {
        // this is the unwind segue - we do not want to get in a loop of showing the
        // location manager when they hit cancel or if they deny
        showLocationRequest = false
    }

    //MARK: - TableDatasource functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath)
        
        if let cell = cell as? MainTableViewCell {
            
            cell.currentWeather = dataSource[indexPath.row]

            // setup the main label text
            let labeltext = "\(cell.currentWeather.name ?? "No City Name"): \(cell.currentWeather.main?.temp ?? -9999) degrees"
            cell.weatherDetailLabel.text = labeltext

            // setup the image
            if let ci = cell.currentWeather.weather?[0],
                let img = ci.icon {
                cell.weatherImage.cacheImage("https://openweathermap.org/img/w/\(img).png")
            } else {
                cell.weatherImage = nil
            }
        }
        
        return cell

    }
    
    //MARK: - TableView Delegate functions
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
    
    }
    
    //MARK: - Supporting functions
    func reloadData() {
        
        // reload the data
        if let currentLocation = currentLocation {
            mainViewModel.currentLocation = currentLocation
        }
        
        mainViewModel.updateData { (data) in
            self.dataSource = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
