//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchInputField: UITextField!
    var weatherManager = WeatherManager()
    var locationManager=CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchInputField.delegate=self
        weatherManager.delegate=self
        locationManager.delegate = self
        // Do any additional setup after loading the view.
    }
    func initialiseAndGetLocation(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
 
    @IBAction func currentLocationImage(_ sender: UIButton) {
        initialiseAndGetLocation()
    }
}
extension WeatherViewController : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locationSafe = locations.last {
            locationManager.stopUpdatingLocation()
            let latitude = locationSafe.coordinate.latitude
            let longitude = locationSafe.coordinate.longitude
            print(" Lat \(latitude) ,  Longitude \(longitude)")
            weatherManager.fetchWeatherByLocation(latitude,longitude)
        }
        if locations.first != nil {
            print("location:: \(locations[0])")
        }

    }

}
extension WeatherViewController:WeatherManagerDelegate{
    func didUpdateWidgetUi(_ weatherManager: WeatherManager, weatherModel: WeatherModel) {
        print("inside didUpdateWidgetUi \(weatherModel)")
        DispatchQueue.main.async {
            self.temperatureLabel.text=weatherModel.tempInString
            self.cityLabel.text = weatherModel.name
            self.conditionImageView.image = UIImage(systemName: weatherModel.conditionName)
        }
        
    }
    
    func onError(_ error: Error) {
        print("inside onerror \(error)")
    }
}

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        searchInputField.endEditing(true)
        weatherManager.fetchWeather(cityName: searchInputField.text!)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchInputField {
            print("Changes done in searchTextField")
            searchInputField.resignFirstResponder()
            if textField.text != "" {
                return true
            }
            else {
                textField.placeholder = "Type something..."
                return false
            }
        }
        // it hides the keyboard
           //performAction()
          // print(" Inside textFieldShouldReturn")
           return true
       }
       
      
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == searchInputField {
            if let city = searchInputField.text {
                weatherManager.fetchWeather(cityName: searchInputField.text!)
            }

        }
    }
}
