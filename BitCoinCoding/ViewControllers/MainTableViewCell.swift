//
//  MainTableViewCell.swift
//  BitCoinCoding
//
//  Created by Mike Silvers on 5/29/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    public var currentWeather = CurrentWeather()
    
    @IBOutlet var weatherImage       : UIImageView!
    @IBOutlet var weatherDetailLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
