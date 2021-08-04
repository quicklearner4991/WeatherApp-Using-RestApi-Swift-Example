//
//  WeatherManager.swift
//  Clima
//
//  Created by Raman on 18/07/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    var delegate : WeatherManagerDelegate?
    
    let url="http://api.openweathermap.org/data/2.5/weather?appid=put_key_here&units=metric"
    
    func fetchWeather(cityName:String){
        let apiurl = "\(url)&q=\(cityName)"
        print( apiurl)
        requestUrl(with: apiurl)
    }
    func fetchWeatherByLocation(_ latitude:Double,_ longitude:Double){
        let apiurl = "\(url)&lat=\(latitude)&lon=\(longitude)"
        print( apiurl)
        requestUrl(with: apiurl)
    }
    func requestUrl(with url:String) {
        if  let url = URL(string: url){
        let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("Error \(error)")
                    delegate?.onError(error as! Error)
                    return
                }
                if let safeData = data {
                   // let dataInString = String(data: data!, encoding: .utf8)
                    if let safeWeatherModel = self.parseJson(safeData){
                        self.delegate?.didUpdateWidgetUi(self, weatherModel:safeWeatherModel)
                    }
//                    if let safeWeatherModel = self.parseJson(data: safeData) {
//                        delegate?.didUpdateWidgetUi(safeWeatherModel:WeatherModel)
//                    }
   
                }

            }
            task.resume()
        }
    }
    
    func parseJson(_ data:Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
           let weatherData =  try decoder.decode(WeatherData.self, from: data)
            let weatherModel = WeatherModel(name: weatherData.name, conditionId: weatherData.weather[0].id, temp: weatherData.main.temp)
            return weatherModel
            
        } catch {
            print(error)
            delegate?.onError(error)
        }
        return nil
    }
   
   
}
