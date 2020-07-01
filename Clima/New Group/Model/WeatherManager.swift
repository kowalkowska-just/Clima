

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    var weatherURL = "https://api.openweathermap.org/data/2.5/weather?&units=metric&lang=pl&appid=\(Key.key)"

    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) { //pobierz pogode
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }

    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) ->  WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodeData.name
            let temp = decodeData.main.temp
            let id = decodeData.weather[0].id
            let descrip = decodeData.weather[0].description
        
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, description: descrip)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

extension WeatherManager {
    
    func fetchWeather(laticude: Double, longitude: Double) {
        let urlString = "\(weatherURL)&lat=\(laticude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
}
