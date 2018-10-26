//
//  Weather.swift
//  TestOpenForecast
//
//  Created by Светлана Лобан on 10/22/18.
//  Copyright © 2018 Sviatlana Loban. All rights reserved.
//

import Foundation

struct ForecastInstance : Decodable {
    let list: [ForecastList]?
    let city : City?
}

struct ForecastList : Decodable {
    let dt : String?
    let weather : [Weather]?
    let main : Main?
    
    private enum CodingKeys : String, CodingKey {
        case dt = "dt_txt"
        case weather, main
    }
}

struct City : Decodable {
    let name: String
}

//struct Coord : Decodable {
//    let lon : Float
//    let lat : Float
//}

struct Main : Decodable{
    let temp : Double
//    let pressure : Int
//    let humidity : Int
//    let temp_min: Double
//    let temp_max: Double
}

struct Weather : Decodable{
//    let id : Int
//    let main: String
    let descr: String
    let icon: String
    
    private enum CodingKeys : String, CodingKey {
        case descr = "description"
        case icon
    }
}
