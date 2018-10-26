//
//  ViewController.swift
//  TestOpenForecast
//
//  Created by Светлана Лобан on 10/19/18.
//  Copyright © 2018 Sviatlana Loban. All rights reserved.
//

import UIKit
import MapKit

let kShowDetail = "kShowDetail"

//struct ForecastParameters {
//    var lat = ""
//    var lon = ""
//    let aPPID = ""
//}

class MapVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var worldMapView: MKMapView!
    var parameters: ForecastParameters?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addGesture()
        worldMapView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addGesture() {
        let tapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(gestureRecognizerShouldBegin))
        //tapGestureRecognizer.numberOfTapsRequired = 1
        //tapGestureRecognizer.numberOfTouchesRequired = 1
        tapGestureRecognizer.minimumPressDuration = 1
        worldMapView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.state == .began {
            let point = gestureRecognizer.location(in: worldMapView)
            let tapPoint = worldMapView.convert(point, toCoordinateFrom: worldMapView)
            print("lat = \(tapPoint.latitude), long = \(tapPoint.longitude)")
            parameters = ForecastParameters(lat: String(tapPoint.latitude), lon: String(tapPoint.longitude))
            performSegue(withIdentifier: kShowDetail, sender: self)
            
            let annotations = self.worldMapView.annotations
            self.worldMapView.removeAnnotations(annotations)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = tapPoint
            self.worldMapView.addAnnotation(annotation)
        }
        
        return true
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        // Don't want to show a custom image if the annotation is the user's location.
//        guard !(annotation is MKUserLocation) else {
//            return nil
//        }
//
//        // Better to make this class property
//        let annotationIdentifier = "id"//kShowDetail
//
//        var annotationView: MKAnnotationView?
//        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
//            annotationView = dequeuedAnnotationView
//            annotationView?.annotation = annotation
//        }
//        else {
//            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
//            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//            annotationView = av
//        }
//
//        if let annotationView = annotationView {
//            // Configure your annotation view here
//            annotationView.canShowCallout = true
//            annotationView.image = UIImage(named: "close")
//        }
//
//        return annotationView
//    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "id"//kShowDetail
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "close")
            //let vc = storyboard?.instantiateViewController(withIdentifier: "forecastVC") as! DetailVC
//            let vc = DetailVC()
//            vc.coordinates = self.parameters
//            //vc.tableView.delegate = vc
//            //vc.tableView.dataSource = vc
//            annotationView.addSubview(vc.view)
//            vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        return annotationView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kShowDetail {
            guard let detailVC = segue.destination  as? DetailVC else { return }
            let param = self.parameters
            detailVC.coordinates = param
        }
    }
    
}

