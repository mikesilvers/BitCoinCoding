//
//  DetailViewController.swift
//  BitCoinCoding
//
//  Created by Mike Silvers on 5/29/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var currentWeather = CurrentWeather()
    
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var windLabel: UILabel!
    @IBOutlet var cloudLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cityLabel.text  = currentWeather.name ?? "No City"
        cloudLabel.text = "\(currentWeather.clouds?.all ?? 0)% cloud coverage"
        windLabel.text  = "\(currentWeather.wind?.speed ?? 0) mph at \(currentWeather.wind?.deg ?? 0) degrees"

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
