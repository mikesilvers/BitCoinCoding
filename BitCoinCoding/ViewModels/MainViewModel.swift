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

class MainViewModel {
    
    private func parseSingleJSON(_ json: Data) -> CurrentWeather? {

        // this is a single location request
        guard let cw = try? JSONDecoder().decode(CurrentWeather.self, from: json) else { return nil }
        
        // this process will get all current weather and append it to the main return
        return cw

    }

    private func parseMultiJSON(_ json: Data) -> [CurrentWeather]? {
        
        // this is a multi city request
        guard let cw = try? JSONDecoder().decode(CurrentWeatherArray.self, from: json) else { return nil }
        
        // this process will get all current weather and append it to the main return
        return cw.list ?? []
        
    }

}
