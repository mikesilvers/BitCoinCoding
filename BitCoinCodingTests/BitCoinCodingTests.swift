//
//  BitCoinCodingTests.swift
//  BitCoinCodingTests
//
//  Created by Mike Silvers on 5/29/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import XCTest
@testable import BitCoinCoding

class BitCoinCodingTests: XCTestCase {

    var bundle = Bundle()
    
    override func setUp() {
        bundle = Bundle(for: type(of: self))
    }

    func testWeatherObjectDecodingFromKnownJSONFiles() {
        
        var weather = CurrentWeather()
        
        // read the test JSON file
        if let filepath = bundle.path(forResource: "LatLon_Weather", ofType: "json"),
            let fileData = try? String(contentsOfFile: filepath).data(using: .utf8) {
            
            // parse out the weather
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                weather = try decoder.decode(CurrentWeather.self, from: fileData)
            } catch {
                print(error)
                XCTAssert(false, "There was a problem parsing the file")
                // no need for any other tests if the file did not parse
                return
            }
            
        } else {
            XCTAssert(false, "The file LatLon_Weather.json does not exist.")
        }
        
        // look at the weather results now
        XCTAssertTrue(weather.base == "stations")
        XCTAssertTrue(weather.visibility == 16093)
        XCTAssertTrue(weather.dt == 1559147652)
        XCTAssertTrue(weather.timezone == -14400)
        XCTAssertTrue(weather.id == 4138106)
        XCTAssertTrue(weather.name == "District of Columbia")
        XCTAssertTrue(weather.cod == 200)
        
        // test the sys section
        if let data = weather.sys {
            XCTAssertTrue(data.country == "US")
            XCTAssertTrue(data.id == 3787)
            XCTAssertTrue(data.message == 0.0104)
            XCTAssertTrue(data.sunrise == 1559123172)
            XCTAssertTrue(data.sunset == 1559175909)
            XCTAssertTrue(data.type == 1)
        } else {
            XCTAssert(false, "The 'sys' section is missing")
        }

        // test the clouds section
        if let data = weather.clouds {
            XCTAssertTrue(data.all == 75)
        } else {
            XCTAssert(false, "The 'clouds' section is missing")
        }

        // test the wind section
        if let data = weather.wind {
            XCTAssertTrue(data.deg == 220)
            XCTAssertTrue(data.speed == 4.1)
        } else {
            XCTAssert(false, "The 'wind' section is missing")
        }

        // test the main section
        if let data = weather.main {
            XCTAssertTrue(data.temp == 304.86)
            XCTAssertTrue(data.pressure == 1007)
            XCTAssertTrue(data.humidity == 43)
            XCTAssertTrue(data.temp_max == 306.48)
            XCTAssertTrue(data.temp_min == 303.15)
        } else {
            XCTAssert(false, "The 'main' section is missing")
        }

        // test the weather section
        if let data = weather.weather {
            // test for the number of results in the array
            XCTAssertTrue(data.count == 1)
            // test the individual results
            for d in data {
                XCTAssertTrue(d.description == "broken clouds")
                XCTAssertTrue(d.icon == "04d")
                XCTAssertTrue(d.id == 803)
                XCTAssertTrue(d.main == "Clouds")
            }

        } else {
            XCTAssert(false, "The 'weather' array is missing")
        }

        // test the coordinates section
        if let data = weather.coord {
            XCTAssertTrue(data.lat == 38.92)
            XCTAssertTrue(data.lon == -77.03)
        } else {
            XCTAssert(false, "The 'coord' section is missing")
        }

    }
    
    func testWeatherCityArrayFromKnownJSONFiles() {
        
        var weather = [CurrentWeather]()
        
        // read the test JSON file
        if let filepath = bundle.path(forResource: "MultiCity_Weather", ofType: "json"),
            let fileData = try? String(contentsOfFile: filepath).data(using: .utf8) {
            
            // parse out the weather
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let weatherArray = try decoder.decode(CurrentWeatherArray.self, from: fileData)
                weather = weatherArray.list ?? [CurrentWeather]()
            } catch {
                print(error)
                XCTAssert(false, "There was a problem parsing the file")
                // no need for any other tests if the file did not parse
                return
            }
            
        } else {
            XCTAssert(false, "The file MultiCity_Weather.json does not exist.")
        }
        
        // check to make sure the correct number of recirds are here
        XCTAssertTrue(weather.count == 2, "The weather array has \(weather.count) items, expecting 2")

    }
    
    func testWeatherEquatable() {
        
        // read the sample data and get ourselves for testing
        var weather = [CurrentWeather]()
        
        // read the test JSON file
        if let filepath = bundle.path(forResource: "MultiCity_Weather", ofType: "json"),
            let fileData = try? String(contentsOfFile: filepath).data(using: .utf8) {
            
            // parse out the weather
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let weatherArray = try decoder.decode(CurrentWeatherArray.self, from: fileData)
                weather = weatherArray.list ?? [CurrentWeather]()
            } catch {
                print(error)
                XCTAssert(false, "There was a problem parsing the file")
                // no need for any other tests if the file did not parse
                return
            }
            
        } else {
            XCTAssert(false, "The file MultiCity_Weather.json does not exist.")
        }
        
        // check to make sure the correct number of recirds are here
        XCTAssertTrue(weather.count == 2, "The weather array has \(weather.count) items, expecting 2")

        // lets start the tests
        var w1 = weather[0]
        let w2 = weather[0]

        XCTAssertTrue(w1 == w2)

        // test with a new weather array for the current weather
        w1.weather = [Weather(id: 111111, main: nil, icon: "o)1", description: "weather")]
        XCTAssertFalse(w1 == w2)
        
        // making changes to the snow
        w1 = w2
        w1.snow = WeatherSnow(OneH: 1, ThreeH: 10)
        XCTAssertFalse(w1 == w2)

        // making changes to the base name
        w1 = w2
        w1.base = "Test"
        XCTAssertFalse(w1 == w2)

        // making changes to the clouds
        w1 = w2
        w1.clouds = WeatherClouds(all: 10)
        XCTAssertFalse(w1 == w2)

        // making changes to the cod
        w1 = w2
        w1.cod = 2
        XCTAssertFalse(w1 == w2)

        // making changes to the weather coordinate
        w1 = w2
        w1.coord = WeatherCoordinate(lat: 1.0, lon: -1.0)
        XCTAssertFalse(w1 == w2)

        // making changes to the time
        w1 = w2
        w1.dt = 1
        XCTAssertFalse(w1 == w2)

        // making changes to the id
        w1 = w2
        w1.id = 23456
        XCTAssertFalse(w1 == w2)

        // test again
        w1 = w2
        w1.main = WeatherMain(temp: 100.0,
                              pressure: 20,
                              humidity: 20,
                              temp_min: nil,
                              temp_max: nil,
                              sea_level: nil,
                              grnd_level: nil)
        XCTAssertFalse(w1 == w2)

        // making changes to the rain
        w1 = w2
        w1.rain = WeatherRain(OneH: 2, ThreeH: 2)
        XCTAssertFalse(w1 == w2)

        // making changes to the sys
        w1 = w2
        w1.sys = WeatherSys(id: 12345,
                            type: 3,
                            sunset: nil,
                            sunrise: nil,
                            message: 10.2,
                            country: nil)
        XCTAssertFalse(w1 == w2)

        // making changes to the timezone
        w1 = w2
        w1.timezone = -14400
        XCTAssertFalse(w1 == w2)

        // making changes to the wind
        w1 = w2
        w1.wind = WeatherWind(deg: 230, speed: 5.5)
        XCTAssertFalse(w1 == w2)

        
    }
}
