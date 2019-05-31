//
//  MainViewModel.swift
//  BitCoinCoding
//
//  Created by Mike Silvers on 5/29/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import Foundation
import CoreLocation

/**
 The main view model manages the data for the main view.
 
 Controls and manages the data for the main view for display.
 */
class MainViewModel {
    
    // MARK: - Variables
    var currentLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    // MARK: - Internal variables
    private static let weatherKey = "0ff943e7d5281ba0fba4d1d63f43039f"
    
    /**
     Main function to update the data.
     
     This function is used to update the information for display in the main view.  This is the function
     the main view calls to update all information.
     
     ** NOTE: Prior to calling this function, the current location must be set to include
              the users current locsation weather.
     
     - Parameter completion: The completion block to return the current weather array.
     - Parameter [CurrentWeather]: The array of `CurrentWeather` objects containing all current weather information.
    */
    func updateData(_ completion: @escaping ([CurrentWeather])->Void) {
        
        // the array to return
        var totalArray = [CurrentWeather]()
        
        // the completion blocks to make the async calls sync calls
        // first call is the weather by location
        // second call are the two designated cities
        MainViewModel.weatherBy(self.currentLocation) { (data) in
            totalArray.append(contentsOf: data)
            MainViewModel.weatherFromTwoCities() { (data) in
                totalArray.append(contentsOf: data)
                completion(totalArray)
            }
        }
    }
    
    // MARK: - Support Functions
    
    /**
     Private function to retrieve weather at the users location
     
     This function will return weather using the users coordinates.  If there are no coordinates for the user,
     then an empty array is returned.
     
     - Parameter location: A CLLocationCoordinate2D representing the location centering the weather report.
     - Parameter completion: the completion block for the return of the information
     - Parameter [CurrentWeather]: The array of current weather objects returned
     
    */
    private static func weatherBy(_ location: CLLocationCoordinate2D,_ completion: @escaping ([CurrentWeather])->Void) {
        
        // only perform this function if coordinates were passed in
        if location.latitude != 0.0 && location.longitude != 0.0 {
        
            // this is the base URL for a single current weather request
            let locWeather = "https://api.openweathermap.org/data/2.5/weather"
        
            // process the weather request
            MainViewModel.webInquiry(locWeather, ["lat":"\(location.latitude)","lon":"\(location.longitude)","units":"imperial","APPID":"\(weatherKey)"]) {
                    (response, data, error) in
                    
                    // check to see if the data came back correctly
                    if let data = data {
                        completion(MainViewModel.parseSingleJSON(data))
                    }
                }
        } else {
            // no coordinates, return an empty array
            completion([])
        }
        
    }
    
    /**
     Private function to retrieve weather from designated cities
     
     This function will return weather from designated cities using the ID for the cities as assigned by Open Weather.
     
     - Parameter completion: the completion block for the return of the information
     - Parameter [CurrentWeather]: The array of current weather objects returned
     
     */
    private static func weatherFromTwoCities(_ completion: @escaping ([CurrentWeather])->Void) {

        // the URL for groups of weather reports
        let twoCitiesWeather = "https://api.openweathermap.org/data/2.5/group"
        
        // process the request
        MainViewModel.webInquiry(twoCitiesWeather, ["id":"2643743,1850147","units":"imperial","APPID":"\(weatherKey)"]) {
                (response, data, error) in
                
            // check to see if the data came back correctly
            if let data = data {
                // return the dataset
                completion(MainViewModel.parseMultiJSON(data))
            } else {
                // if there is a server problem, return no information
                completion([])
            }
        }
    }
    
    /**
     Private function to make a web call.
     
     This function makes a web `GET` request using the URL and the query parameters passed.  The responses from the server are returned allowing the requestor to process as needed.
     
     - Parameter urlString: The full URL string, including the protocol (ie: https://) for the web request.
     - Parameter queryParams: The optional query string parameters in a dictionary
     - Parameter completion: The return data
     - Parameter HTTPURLResponse: The optional URL response to provide status codes from the server and related messages.
     - Parameter Data: The optional data returned from the web server.  This is `nil` if there is an error.
     - Parameter Error: The optional error object when an error is encountered.  This is `nil` if there are no errors.
     */
    private static func webInquiry(_ urlString: String,
                                   _ queryParams:[String:String]?,
                                   _ completion : @escaping (HTTPURLResponse?, Data?, Error?)->Void)  {
        
        // setup the URL object for the request
        var url = URL(fileURLWithPath: urlString)
        
        // append the query parms (if there are any)
        if let queryParams = queryParams {
            url.appendQueryItems(queryParams)
        }
        
        // the actual server request
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
    
    /**
     Private function to decode a single weather location response
     
     Decodes the server data into a `CurrentWeather` object array.
     
     - Parameter json: Data type object returned from the server containing JSON.
     - Returns: An array of `CurrentWeather` objects.  An array is returned to allow for the server to return multiple objects for the same location request.
     */
    private static func parseSingleJSON(_ json: Data) -> [CurrentWeather] {

        // this is a single location request
        guard let cw = try? JSONDecoder().decode(CurrentWeather.self, from: json) else { return [] }

        // this process will get all current weather and append it to the main return
        return [cw]

    }

    /**
     Private function to decode a group weather location response
     
     Decodes the server data into a `CurrentWeather` object array.
     
     - Parameter json: Data type object returned from the server containing JSON.
     - Returns: An array of `CurrentWeather` objects.  An array is returned to allow for the server to return multiple objects.
     */
    private static func parseMultiJSON(_ json: Data) -> [CurrentWeather] {
        
        // this is a multi city request
        guard let cw = try? JSONDecoder().decode(CurrentWeatherArray.self, from: json) else { return [] }
        
        // this process will get all current weather and append it to the main return
        return cw.list ?? []
        
    }

}
