//
//  WeatherData.swift
//  Clima
//
//  Created by Raman on 20/07/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name:String
    let main:Main
    let weather:[Weather]
}

struct Main:Decodable {
     let temp:Float
}

struct Weather:Decodable {
    let id:Int
}
