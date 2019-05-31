//
//  MainTableViewCell.swift
//  BitCoinCoding
//
//  Created by Mike Silvers on 5/29/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    //MARK: - variables
    var currentWeather = CurrentWeather()
    
    //MARK: - UI variables
    @IBOutlet var weatherImage       : UIImageView!
    @IBOutlet var weatherDetailLabel : UILabel!

}
