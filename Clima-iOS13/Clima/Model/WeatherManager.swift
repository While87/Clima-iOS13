//
//  WeatherManager.swift
//  Clima
//
//  Created by Vladimir Gorbunov on 9/30/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWhithError(_ error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=9bd94f8d435bdbed242197499c721a07"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String)
    {
        
       let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest (with urlString: String) {
        
        //        1 Create a URL
        if let url = URL(string: urlString) {
            
            //        2 Create a URLSession
            let session = URLSession(configuration: .default)
            
            //        3 Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    delegate?.didFailWhithError(error!)
                    return
                }
                if let safeData = data {
                    if let weather = parseJSON(safeData)
                    {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //        4 Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Weatherdata.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFailWhithError(error)
            return nil
        }
    }
}
