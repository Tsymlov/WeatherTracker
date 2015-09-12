//
//  WeatherInfo.swift
//  Weather
//
//  Created by Alexey Tsymlov on 8/7/15.
//  Copyright (c) 2015 Alexey Tsymlov. All rights reserved.
//

import Foundation

struct WeatherInfo {
    var cityName = ""
    var temperature: Double?
    var forecast = [(String, Double?)]()
}