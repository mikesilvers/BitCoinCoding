//
//  WeatherStructures.swift
//  BitCoinCoding
//
//  Created by Mike Silvers on 5/29/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import Foundation

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
    
    // initializer with the city location object (from Realm)
    init(_ city: CityLocation) {
        id      = city.id
        name    = city.name
        country = city.country
        coord   = WeatherCoordinate(lat: city.latitude, lon: city.longitude)
    }
}

struct WeatherCoordinate: Codable {
    var lat: Double?
    var lon: Double?
}

struct Weather: Codable {
    var id         : Int?
    var main       : String?
    var icon       : String?
    var description: String?
}

struct WeatherMain: Codable {
    var temp      : Double?
    var pressure  : Int?
    var humidity  : Int?
    var temp_min  : Double?
    var temp_max  : Double?
    var sea_level : Double?
    var grnd_level: Double?
}

struct WeatherWind: Codable {
    var deg  : Int?
    var speed: Double?
}

struct WeatherClouds: Codable {
    var all: Int?
}

struct WeatherRain: Codable {
    var OneH  : Int?
    var ThreeH: Int?
    
    enum CodingKeys: String,CodingKey {
        case OneH   = "1h"
        case ThreeH = "3h"
    }
}

struct WeatherSnow: Codable {
    var OneH  : Int?
    var ThreeH: Int?
    
    enum CodingKeys: String, CodingKey {
        case OneH   = "1h"
        case ThreeH = "3h"
    }
}

struct WeatherSys: Codable {
    var id     : Int?
    var type   : Int?
    var sunset : Int?
    var sunrise: Int?
    var message: Double?
    var country: String?
}

struct CurrentWeatherArray: Codable {
    var cnt  : Int?
    var list : [CurrentWeather]?
}
