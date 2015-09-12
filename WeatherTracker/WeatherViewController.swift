//
//  ViewController.swift
//  WeatherTracker
//
//  Created by Alexey Tsymlov on 9/12/15.
//  Copyright (c) 2015 Specialist. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var forecastLabel0: UILabel!
    @IBOutlet weak var forecastLabel1: UILabel!
    @IBOutlet weak var forecastLabel2: UILabel!
    @IBOutlet weak var forecastLabel3: UILabel!
    
    private var locationManager: CLLocationManager!{
        didSet{
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    private var weatherInfo: WeatherInfo!
    
    override func viewDidLoad() {
        locationManager = CLLocationManager()
    }
    
    struct Constants {
        static let ServiceURL = "http://api.openweathermap.org/data/2.5/forecast"
    }
    
    private func requestWeatherInfo(coordinates: CLLocationCoordinate2D){
        let lat = coordinates.latitude
        let lon = coordinates.longitude
        let url = Constants.ServiceURL
        let params = ["lat":lat, "lon":lon]
        Alamofire.request(.GET, url, parameters: params)
            .responseJSON {(request, response, json, error) in
                if error != nil {
                    println(error)
                    return
                }
                self.initializeWeatherInfo(JSON(json!))
                self.refreshUI()
        }
    }
    
    private func initializeWeatherInfo(json: JSON){
        weatherInfo.temperature = round(json["list"][0]["main"]["temp"].double! - 273.15)
        weatherInfo.cityName = json["city"]["name"].stringValue ?? "unknown"
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        for i in 1...4 {
            let time = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: json["list"][i]["dt"].doubleValue))
            let temperature = round(json["list"][i]["main"]["temp"].double! - 273.15)
            weatherInfo.forecast.append((time, temperature))
        }
    }
    
    private func refreshUI(){
        cityLabel.text = "City: " + weatherInfo.cityName
        temperatureLabel.text = "Current temperature: \(weatherInfo.temperature!)"
        forecastLabel0.text = "\(weatherInfo.forecast[0].0) : \(weatherInfo.forecast[0].1!)"
        forecastLabel1.text = "\(weatherInfo.forecast[1].0) : \(weatherInfo.forecast[1].1!)"
        forecastLabel2.text = "\(weatherInfo.forecast[2].0) : \(weatherInfo.forecast[2].1!)"
        forecastLabel3.text = "\(weatherInfo.forecast[3].0) : \(weatherInfo.forecast[3].1!)"
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var location:CLLocation = locations[locations.count-1] as! CLLocation
        if (location.horizontalAccuracy <= 0) { return }
        self.locationManager.stopUpdatingLocation()
        println(location)
        //requestWeatherInfo(location.coordinate)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error.localizedDescription)
    }
}
