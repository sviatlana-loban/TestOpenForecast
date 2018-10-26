//
//  NetworkService.swift
//  TestOpenForecast
//
//  Created by Светлана Лобан on 10/20/18.
//  Copyright © 2018 Sviatlana Loban. All rights reserved.
//

import Foundation
import Moya

let defaultAPPID = "a10866f6a739ada7aa52d38338391036"

//private func JSONResponseDataFormatter(_ data: Data) -> Data {
//    do {
//        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
//        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
//        return prettyData
//    } catch {
//        return data
//    }
//}

//let openWeatherProvider = MoyaProvider<OpenWeatherService>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])
let openWeatherProvider = MoyaProvider<OpenWeatherService>(plugins: [NetworkLoggerPlugin(verbose: true)])

struct ForecastParameters {
    var lat = ""
    var lon = ""
    let APPID = defaultAPPID
}

enum OpenWeatherService {
    case forecast(parametrs: ForecastParameters)
}

extension OpenWeatherService: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org/data/2.5/")!
    }
    
    var path: String {
        switch self {
        case .forecast:
            return "forecast"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .forecast(let param):
            return .requestParameters(parameters: ["lat": param.lat,
                                                   "lon": param.lon,
                                                   "units": "metric",
                                                   "APPID": param.APPID], encoding: URLEncoding.default)
        }
    }
    
    var validationType: ValidationType {
        return .none
    }
    
    var headers: [String: String]? {
        return nil
    }
}
