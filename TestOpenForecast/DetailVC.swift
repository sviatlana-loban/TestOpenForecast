//
//  ViewController.swift
//  TestOpenForecast
//
//  Created by Светлана Лобан on 10/19/18.
//  Copyright © 2018 Sviatlana Loban. All rights reserved.
//

import UIKit

let cellReuseIdentifier = "forecastCell"

class DetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var forecastInstance : ForecastInstance?
    var coordinates: ForecastParameters!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Weather forecast"
        print(coordinates)
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        request()
    }
    
    func request() {
 //       activityIndicator.startAnimating()
//        DispatchQueue.global().async {
//        openWeatherProvider.request(.forecast(parametrs: coordinates)) { (result) in
//            if case let .success(response) = result {
//                //let jsonString = try? response.mapJSON()
//
//                self.forecastInstance = try? JSONDecoder().decode(ForecastInstance.self, from: response.data)
//                DispatchQueue.main.async { [weak self] in
//                    self?.activityIndicator.stopAnimating()
//                    self?.tableView.isHidden = false
//                    self?.tableView.reloadData()
//                }
//            } else {
//                print(result.error!)
//            }
//        }
        activityIndicator.startAnimating()
        DispatchQueue.global().async {
            sleep(2)
            let path = Bundle.main.path(forResource: "content", ofType: "json")!
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            self.forecastInstance = try? JSONDecoder().decode(ForecastInstance.self, from: data)
                DispatchQueue.main.async { [weak self] in
                    self?.activityIndicator.stopAnimating()
                    self?.tableView.isHidden = false
                    self?.tableView.reloadData()
            }
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let forecastList = self.forecastInstance?.list {
            return forecastList.count
        }
        return 0
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! ForecastTableViewCell
        
        if let forecast = forecastInstance?.list?[indexPath.row] {
            if let dt = forecast.dt, let temp = forecast.main?.temp, let descr = forecast.weather?[0].descr, let icon = forecast.weather?[0].icon {
                cell.temperatureLabel.text = temp.prettyString
                cell.dateLabel.text =  Date.getDateString(date: dt)
                cell.timeLabel.text = Date.getTimeString(date: dt)
                cell.descriptionLabel.text = descr
                cell.imageURL = URL(string: "https://openweathermap.org/img/w/" + icon + ".png")                
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return forecastInstance?.city?.name ?? ""
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
//    func downloadImage(from url: URL) {
//        var iconUrl = "http://openweathermap.org/img/w/" + iconCode + ".png";
//        print("Download Started")
//        getData(from: url) { data, response, error in
//            guard let data = data, error == nil else { return }
//            print(response?.suggestedFilename ?? url.lastPathComponent)
//            print("Download Finished")
//            DispatchQueue.main.async() {
//                self.imageView.image = UIImage(data: data)
//            }
//        }
//    }
    



}

extension Date {
    static func getDateString(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        
        let formateDate = dateFormatter.date(from: date)!
        dateFormatter.dateFormat = "dd MMM"
        
        return dateFormatter.string(from: formateDate);
    }
    
    static func getTimeString(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        
        let formateDate = dateFormatter.date(from: date)!
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: formateDate);
    }
}

extension Double {
    var prettyString: String {
        var str = ""
        if (!str.hasPrefix("-")) {
            str += "+"
        }
        str += String(format: "%.1f", self) + "°C"
        return str
    }
}


