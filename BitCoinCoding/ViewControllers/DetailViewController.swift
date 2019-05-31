//
//  DetailViewController.swift
//  BitCoinCoding
//
//  Created by Mike Silvers on 5/29/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - Variables
    var currentWeather = CurrentWeather()
    
    //MARK: - UI variables
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var windLabel: UILabel!
    @IBOutlet var cloudLabel: UILabel!

    //MARK: - View functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // setup the lables and such with the correct information
        cityLabel.text  = currentWeather.name ?? "No City"
        cloudLabel.text = "\(currentWeather.clouds?.all ?? 0)% cloud coverage"
        windLabel.text  = "\(currentWeather.wind?.speed ?? 0) mph at \(currentWeather.wind?.deg ?? 0) degrees"

        navigationItem.title = "Weather Details"

    }

}
