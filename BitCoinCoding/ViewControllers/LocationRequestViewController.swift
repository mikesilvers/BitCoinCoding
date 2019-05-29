//
//  ViewController.swift
//  BitCoinCoding
//
//  Created by Mike Silvers on 5/29/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import UIKit
import CoreLocation

class LocationRequestViewController: UIViewController {

    // MARK: - UI Variables
    @IBOutlet var cancelButton : UIButton!
    @IBOutlet var youBetButton : UIButton!
    
    @IBOutlet var titleLabel   : UILabel!
    @IBOutlet var messageLabel : UILabel!

    // MARK: Public variables
    var locationManager : CLLocationManager?

    // MARK: - View functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // setting up the title label wording and the request wording
        var message = ""
        var title   = "Requesting Location"
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            print("Nothing")
        case .notDetermined:
            message = "We would like to give you the weather.  So... we need your location.  Please allow us to use your location when the app is in use.\n\nWhen the Apple prompt comes up, select the 'Allow' option.  Thanks!"
        case .denied:
            message = "Oops.... it looks like you may have accidentally denied us to use your location.\n\nPlease change your location settings in settings.\n\nJust touch the 'You Bet' button."
            title = "Requesting Location Again"
        default:
            message = "Not sure whats up here, but we need your location to find out the local weather."
        }
        
        // set the message to the label
        messageLabel.text = message
        titleLabel.text   = title
    }
    
    // MARK: - Button functions
    @IBAction func youBetButton(_ sender: UIButton) {
        
        // this view will not be presented if they already authorized location,
        // so we only need to deal with denied and the others
        let permission = CLLocationManager.authorizationStatus()
        if permission == .denied {
            // request a change of settings
            // this will take us directly to the settings
            if let url = URL(string:UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            
        } else {
            // request permission (when is use only - the lease permission we need)
            locationManager?.requestWhenInUseAuthorization()
        }
        
        // unwind the segue so we so not have a loop of location requests
        performSegue(withIdentifier: "returnFromLocationSegue", sender: nil)
    }


}

