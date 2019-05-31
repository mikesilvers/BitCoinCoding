//
//  MainViewModel.swift
//  BitCoinCoding
//
//  Created by Mike Silvers on 5/29/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import Foundation
import CoreLocation

class MainViewModel {
    
    // MARK: - Variables
    var currentLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    // MARK: - Internal variables
    private static let weatherKey = "0ff943e7d5281ba0fba4d1d63f43039f"
    
    func updateData(_ completion: @escaping ([CurrentWeather])->Void) {
        
        var totalArray = [CurrentWeather]()
        
        MainViewModel.weatherBy(self.currentLocation) { (data) in
            totalArray.append(contentsOf: data)
            MainViewModel.weatherFromTwoCities() { (data) in
                totalArray.append(contentsOf: data)
                completion(totalArray)
            }
        }
    }
    
    
    // MARK: - Support Functions
    private static func weatherBy(_ location: CLLocationCoordinate2D,_ completion: @escaping ([CurrentWeather])->Void) {
        
        if location.latitude != 0.0 && location.longitude != 0.0 {
        
            let locWeather = "https://api.openweathermap.org/data/2.5/weather"
        
            MainViewModel.webInquiry(locWeather, ["lat":"\(location.latitude)","lon":"\(location.longitude)","units":"imperial","APPID":"\(weatherKey)"]) {
                    (response, data, error) in
                    
                    // check to see if the data came back correctly
                    if let data = data {
                        completion(MainViewModel.parseSingleJSON(data))
                    }
                }
        } else {
            completion([])
        }
        
    }
    
    private static func weatherFromTwoCities(_ completion: @escaping ([CurrentWeather])->Void) {

        let twoCitiesWeather = "https://api.openweathermap.org/data/2.5/group"
        
        MainViewModel.webInquiry(twoCitiesWeather, ["id":"2643743,1850147","units":"imperial","APPID":"\(weatherKey)"]) {
                (response, data, error) in
                
            // check to see if the data came back correctly
            if let data = data {
                completion(MainViewModel.parseMultiJSON(data))
            }
        }
    }
    
    private static func webInquiry(_ urlString: String,
                                   _ queryParams:[String:String]?,
                                   _ completion : @escaping (HTTPURLResponse?, Data?, Error?)->Void)  {
        
        var url = URL(fileURLWithPath: urlString)
        
        if let queryParams = queryParams {
            url.appendQueryItems(queryParams)
        }
        
        URLSession.shared.dataTask(with: url) { (theData, response, error) in
            
            // prepare the response for return in the completion
            let httpResponse = response as? HTTPURLResponse
            
            // Check the URLSession Error:
            if (error == nil) {
                // return the completion when there is no error
                completion(httpResponse, theData, error)
            } else {
                // return the completion when there is an error
                completion(httpResponse, nil, error)
            }
            
        }.resume()

    }
    
    private static func parseSingleJSON(_ json: Data) -> [CurrentWeather] {

        // this is a single location request
        guard let cw = try? JSONDecoder().decode(CurrentWeather.self, from: json) else { return [] }

        // this process will get all current weather and append it to the main return
        return [cw]

    }

    private static func parseMultiJSON(_ json: Data) -> [CurrentWeather] {
        
        // this is a multi city request
        guard let cw = try? JSONDecoder().decode(CurrentWeatherArray.self, from: json) else { return [] }
        
        // this process will get all current weather and append it to the main return
        return cw.list ?? []
        
    }

}
