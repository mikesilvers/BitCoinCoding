//
//  BitCoinCodingTests.swift
//  BitCoinCodingTests
//
//  Created by Mike Silvers on 5/29/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import RealmSwift

import XCTest
@testable import BitCoinCoding

class BitCoinCodingTests: XCTestCase {

    var bundle = Bundle()
    
    override func setUp() {
        bundle = Bundle(for: type(of: self))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWeatherDecoding() {
        
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
    
    func testRealmLookup() {
        
        let filename = Bundle.main.path(forResource: "cities", ofType: "realm")
        if let filename = filename {
            let url = URL(fileURLWithPath: filename)
            if let realmTest = try? Realm(fileURL: url) {
                // lets lookup London
                var predicate = NSPredicate(format: "name = %@ AND country = %@", "London", "GB")
                var city = realmTest.objects(CityLocation.self).filter(predicate)
                
                XCTAssertTrue(city.count == 1, "Expecting 1 entry for London, found \(city.count)")
                
                // lets lookup Tokyo
                predicate = NSPredicate(format: "name = %@ AND country = %@", "Tokyo","JP")
                city = realmTest.objects(CityLocation.self).filter(predicate)
                
                XCTAssertTrue(city.count == 1, "Expecting 1 entry for Tokyo, found \(city.count)")
                
            } else {
                XCTAssert(false, "There was a problem locating the database")
            }
        }
    }
}
