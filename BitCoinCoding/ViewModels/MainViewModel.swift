//
//  MainViewModel.swift
//  BitCoinCoding
//
//  Created by Mike Silvers on 5/29/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation
import CoreLocation

class MainViewModel {
    
    // MARK: - Variables
    var currentLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    // MARK: - Internal variables
    private static let weatherKey = "0ff943e7d5281ba0fba4d1d63f43039f"
    
    //MARK: - Observation variables
    let weatherLocation = BehaviorRelay(value: CurrentWeather())

    lazy var data: Driver<[CurrentWeather]> = {
        
        let merge = self.weatherLocation.asObservable()
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .flatMap { _ in
                MainViewModel.weatherFromTwoCities()
            }
            .flatMap { weather in
                MainViewModel.weatherBy(self.currentLocation).flatMapLatest { response in
                    Observable.merge(Observable.just(weather), Observable.just(response))
                }
            }
//            .flatMapLatest { _ in
//                MainViewModel.weatherFromTwoCities()
//            }
//            .flatMapLatest { weather in
//                MainViewModel.weatherBy(self.currentLocation).flatMapLatest { response in
//                    Observable.merge(Observable.just(weather), Observable.just(response))
//                }
//            }
            .asDriver(onErrorJustReturn: [])

        return merge
    }()
    
    func reloadData() {
        weatherLocation.accept(CurrentWeather())
    }
    
    // MARK: - Support Functions
    static func weatherBy(_ location: Any?) -> Observable<[CurrentWeather]> {
        
        if let location2D = location as? CLLocationCoordinate2D,
            location2D.latitude != 0.0 && location2D.longitude != 0.0 {
        
            let locWeather = "https://api.openweathermap.org/data/2.5/weather?lat=\(location2D.latitude)&lon=\(location2D.longitude)&units=imperial&APPID=\(weatherKey)"
        
            if let locationWeatherURL = URL(string: locWeather) {
        
                return URLSession.shared.rx.data(request: URLRequest(url: locationWeatherURL))
                    .retry(3)
                    .map(parseSingleJSON)
            }
        }
        
        // no location - just an empty
        return Observable.just([])
    }
    
    static func weatherFromTwoCities() -> Observable<[CurrentWeather]> {

        let twoCitiesWeather = "https://api.openweathermap.org/data/2.5/group?id=2643743,1850147&units=imperial&APPID=\(weatherKey)"
        
        guard let twoCitiesWeatherURL = URL(string: twoCitiesWeather) else {
            return Observable.just([])
        }

        return URLSession.shared.rx.data(request: URLRequest(url: twoCitiesWeatherURL))
            .retry(3)
            .map(parseMultiJSON)
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
