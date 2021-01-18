//
//  WeatherViewModel.swift
//  FinalProject_147
//
//  Created by User20 on 2020/12/22.
//

import SwiftUI


class WeatherViewModel: ObservableObject {
    
    @Published var locationWeather = LocationWeather(locationName: "taipei", lat: "121", lon: "25", weatherElement: [WeatherElement(elementName: "降雨", description: "big rain", time: [MyTime(startTime: "adfad", endTime: "dafad", elementValue:[ElementValue(value: "100", measures: "percent"), ElementValue(value: "100", measures: "percent"), ElementValue(value: "100", measures: "percent"), ElementValue(value: "100", measures: "percent")])])])
    
    func fetchWeathers(city: String) {
        
        if let urlStr = "https://opendata.cwb.gov.tw/api/v1/rest/datastore/F-D0047-091?Authorization=CWB-D3527C4D-45D1-406F-995A-1DF327B73F04&locationName=\(city)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlStr)
            {
            URLSession.shared.dataTask(with: url) { (data, response ,
                                                     error) in
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                if let data = data,
                   let weatherResult = try?
                    decoder.decode(WeatherResult.self, from: data) {
                    DispatchQueue.main.async {
                        self.locationWeather = weatherResult.records.locations[0].location[0]
                    }//把東西加到main queue
                    //self.locationWeathers = weatherResult.records.location
                    print("fetch Weather success")
                }
            }.resume()
        
            
        }
    }
}
