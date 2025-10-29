//
//  ForecastBuilder.swift
//

protocol ForecastBuildable {
    func buildNews(response: TestServiceModel) -> TestDomainModel
    func buildForecast(response: ForecastResponse) -> ForecastModel
}

class ForecastBuilder: ForecastBuildable {
    static let shared = ForecastBuilder()
    
    func buildNews(response: TestServiceModel) -> TestDomainModel {
        TestDomainModel(
            newsToday: response.news_today,
            bestSeller: response.best_seller
        )
    }
    
    func buildForecast(response: ForecastResponse) -> ForecastModel {
        let items = response.list.compactMap { item -> ForecastItemModel in
            let tempInfo = TempratureInfoModel(temp: item.main.temp,
                                               temp_min: item.main.temp_min,
                                               temp_max: item.main.temp_max
            )
            let weatherInfo = item.weather.compactMap { weather in
                WeatherInfoModel(description: weather.description,
                                 icon: weather.icon
                )
            }
            return ForecastItemModel(date: item.dt,
                                     temperatureInfo: tempInfo,
                                     forecatDays: item.dt_txt,
                                     weatherInfo: weatherInfo
            )
        }
        return ForecastModel(list: items,
                             city: CityModel(timezone: response.city.timezone)
        )
    }
}
