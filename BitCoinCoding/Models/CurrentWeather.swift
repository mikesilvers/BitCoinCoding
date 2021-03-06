//
//  CurrentWeather.swift
//  BitCoinCoding
//
//  Created by Mike Silvers on 5/29/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import Foundation

/**
 A container for the current weather conditions.
 
 Contains all related information about the current weather for a specific location.
 All variables are optional to easily decode the JSON document.
 */
struct CurrentWeather : Codable, Equatable {
    
    var coord: WeatherCoordinate?
    var weather: [Weather]?
    var base: String?
    var visibility: Double?
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
    
    //MARK: - Equatable functions
    static func == (lhs: CurrentWeather, rhs: CurrentWeather) -> Bool {
        
        // get the string representations of the data
        var lhsDump = String()
        dump(lhs, to: &lhsDump)
        
        var rhsDump = String()
        dump(rhs, to: &rhsDump)
        
        return rhsDump == lhsDump
    }
}
