//
//  WeatherData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 31.08.22.
//

import Foundation

struct WeatherData: Decodable {
    private(set) var weather: Weather?
    private(set) var daytime: Daytime?
}
