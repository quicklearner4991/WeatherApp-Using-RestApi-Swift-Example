//
//  WeatherManagerDelegate.swift
//  Clima
//
//  Created by Raman on 20/07/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
protocol WeatherManagerDelegate {
    func didUpdateWidgetUi(_ weatherManager: WeatherManager,weatherModel:WeatherModel)
    func onError(_ error:Error)
}
