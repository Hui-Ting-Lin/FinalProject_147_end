//
//  LocationWeather.swift
//  FinalProject_147
//
//  Created by User20 on 2020/12/22.
//

import Foundation

struct WeatherResult: Codable{
    let success: String
    let result: Result
    let records: Locations
}

struct Result: Codable{
    let fields: [Field]
}

struct Field: Codable{
    let id: String
    let type: String
}


struct Locations: Codable{
    let locations: [Location]
}

struct Location: Codable{
    let location: [LocationWeather]
}

struct LocationWeather: Codable, Identifiable{
    let id = UUID()
    let locationName: String
    let lat: String
    let lon: String
    let weatherElement: [WeatherElement]
}

struct WeatherElement: Codable, Identifiable{
    let id = UUID()
    let elementName: String
    let description: String
    /*0: 12小時降雨機率  1: 平均溫度  8:最低溫度  １２：最高溫度 */
    let time: [MyTime]
    
}

struct MyTime: Codable{
    let startTime: String
    let endTime: String
    let elementValue: [ElementValue]
}

struct ElementValue: Codable{
    let value: String
    let measures: String
}

