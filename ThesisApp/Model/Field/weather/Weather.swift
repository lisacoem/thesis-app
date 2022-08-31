//
//  Weather.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 31.08.22.
//

import Foundation

enum Weather: String, CaseIterable, Decodable {
    case thunderstorm = "Thunderstorm",
         drizzle = "Drizzle",
         rain = "Rain",
         snow = "Snow",
         mist = "Mist",
         smoke = "Smoke",
         haze = "Haze",
         dust = "Dust",
         fog = "Fog",
         sand = "Sand",
         ash = "Ash",
         squall = "Squall",
         tornado = "Tornado",
         clear = "Clear",
         clouds = "Clouds"
}
