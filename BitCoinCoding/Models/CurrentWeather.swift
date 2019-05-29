//
//  CurrentWeather.swift
//  BitCoinCoding
//
//  Created by Mike Silvers on 5/29/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import Foundation

struct CurrentWeather : Codable {
    
    var coord: WeatherCoordinate?
    var weather: [Weather]?
    var base: String?
    var visibility: Int?
    var main : WeatherMain?
    var wind : WeatherWind?
    var clouds: WeatherClouds?
    var rain : WeatherRain?
    var snow : WeatherSnow?
    var dt: Int?
    var sys: WeatherSys?
    var id: Int?
    var name: String?
    var cod: Int?
    var timezone: Int?
    
}
