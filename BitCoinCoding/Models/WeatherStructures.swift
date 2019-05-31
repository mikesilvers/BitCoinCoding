//
//  WeatherStructures.swift
//  BitCoinCoding
//
//  Created by Mike Silvers on 5/29/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import Foundation

//MARK: - Weather related support structures

/**
 Contains information related to the city.
 
 Encapsulates information related to the city.
 */
struct WeatherCity: Codable {
    var id     : Int
    var name   : String
    var coord  : WeatherCoordinate
    var country: String
    
    //MARK: Initializers
    
    // default initializer
    init() {
        id      = 0
        name    = ""
        country = ""
        coord   = WeatherCoordinate(lat: 0.0, lon: 0.0)
    }    
}

/**
 Contains the coordinates for a specific point.  This is a
 codable interpreaation of CLLocationCoordinate2D.
 */
struct WeatherCoordinate: Codable {
    var lat: Double?
    var lon: Double?
}

/**
 Provides information related to the weather
 */
struct Weather: Codable {
    var id         : Int?
    var main       : String?
    var icon       : String?
    var description: String?
}

/**
 Provides the main information related to the weather entries.
 */
struct WeatherMain: Codable {
    var temp      : Double?
    var pressure  : Double?
    var humidity  : Double?
    var temp_min  : Double?
    var temp_max  : Double?
    var sea_level : Double?
    var grnd_level: Double?
}

/**
 Provides information related to the wind conditions.
 */
struct WeatherWind: Codable {
    var deg  : Double?
    var speed: Double?
}

/**
 Provides information related to the clouds.
 */
struct WeatherClouds: Codable {
    var all: Int?
}

/**
 Provides information related to the rain conditions.
 */
struct WeatherRain: Codable {
    var OneH  : Double?
    var ThreeH: Double?
    
    enum CodingKeys: String,CodingKey {
        case OneH   = "1h"
        case ThreeH = "3h"
    }
}

/**
 Provides information related to the snow conditions.
 */
struct WeatherSnow: Codable {
    var OneH  : Double?
    var ThreeH: Double?
    
    enum CodingKeys: String, CodingKey {
        case OneH   = "1h"
        case ThreeH = "3h"
    }
}

/**
 Provides general information about the current weather.
 */
struct WeatherSys: Codable {
    var id     : Int?
    var type   : Int?
    var sunset : Int?
    var sunrise: Int?
    var message: Double?
    var country: String?
}

/**
 Encapsulates the current weather when multiple city weather is returned.
 */
struct CurrentWeatherArray: Codable {
    var cnt  : Int?
    var list : [CurrentWeather]?
}
