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
    
    // MARK: - Internal variables
    private static let weatherKey = "0ff943e7d5281ba0fba4d1d63f43039f"
    
    //MARK: - Observation variables
    let weatherLocation = BehaviorRelay(value: CurrentWeather())
    
    lazy var data: Driver<[CurrentWeather]> = {
        
        return self.weatherLocation.asObservable()
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest(MainViewModel.weatherBy)
            .asDriver(onErrorJustReturn: [])
    }()

    // MARK: - Support Functions
    static func weatherBy(_ location: Any) -> Observable<[CurrentWeather]> {
        
        guard let location2D = location as? CLLocationCoordinate2D else { return Observable.just([]) }
        
        let locWeather = "https://api.openweathermap.org/data/2.5/weather?lat=\(location2D.latitude)&lon=\(location2D.longitude)&units=imperial&APPID=\(weatherKey)"
        
        guard let locationWeatherURL = URL(string: locWeather) else {
            return Observable.just([])
        }

        let twoCitiesWeather = "https://api.openweathermap.org/data/2.5/group?id=2643743,1850147&units=imperial&APPID=\(weatherKey)"
        
        guard let twoCitiesWeatherURL = URL(string: twoCitiesWeather) else {
            return Observable.just([])
        }

        
        let weatherByLocation = URLSession.shared.rx.data(request: URLRequest(url: locationWeatherURL))
        .retry(3)
        .map(parseSingleJSON)

        let weatherByCities = URLSession.shared.rx.data(request: URLRequest(url: twoCitiesWeatherURL))
            .retry(3)
            .map(parseSingleJSON)

        return weatherByLocation.concat(weatherByCities)
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
