//
//  ViewController.swift
//  WeatherTracker
//
//  Created by Alexey Tsymlov on 9/12/15.
//  Copyright (c) 2015 Specialist. All rights reserved.
//

import UIKit
import CoreLocation

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
    
    override func viewDidLoad() {
        locationManager = CLLocationManager()
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
