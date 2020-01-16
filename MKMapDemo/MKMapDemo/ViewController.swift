//
//  ViewController.swift
//  MKMapDemo
//
//  Created by Autel-xufeng on 2020/1/16.
//  Copyright © 2020 Autel-iOS. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager?
    var timer: Timer!
    var refreshCount: Int = 0
    var lineOverlay: MKPolyline!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setupMapView()
        
        let centerPoint = CGPoint(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0 + 200)
        let startPoint = CGPoint(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0)
        self.drawLine(centerPoint, startPoint)
        
        self.setupTimer()
    }
    
    private func setupMapView() {
        if CLLocationManager.locationServicesEnabled() {
            self.mapView.showsUserLocation = true
            
            let coordinate2D = CLLocationCoordinate2D(latitude: 22.555196, longitude: 113.969669)
            let zoomLevel = 0.002
            let region = MKCoordinateRegion(center: coordinate2D, span: MKCoordinateSpan(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel))
            self.mapView.setRegion(region, animated: true)
            self.mapView.delegate = self
        }
    }
    
    private func setupTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(refreshLine), userInfo: nil, repeats: true)
    }
    
    @objc private func refreshLine() {
        refreshCount += 1
        let radiu: CGFloat = 200
        let angle: CGFloat = CGFloat(Double.pi) * 2.0 / 600.0 * CGFloat(refreshCount % 600)
        
        let centerPoint = CGPoint(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0)
        let endPoint = CGPoint(x: self.view.bounds.size.width / 2.0 + cos(angle) * radiu, y: self.view.bounds.size.height / 2.0 + sin(angle) * radiu)
        self.drawLine(centerPoint, endPoint)
    }
    
    private func drawLine(_ start: CGPoint, _ end: CGPoint) {
        var coords = [CLLocationCoordinate2D]()
        
        let start2D = self.mapView.convert(start, toCoordinateFrom: self.view)
        coords.append(start2D)
        let end2D = self.mapView.convert(end, toCoordinateFrom: self.view)
        coords.append(end2D)
        
        if self.lineOverlay != nil {
            self.mapView.removeOverlay(self.lineOverlay)
        }
        self.lineOverlay = MKPolyline(coordinates: coords, count: coords.count)
        self.mapView.addOverlay(self.lineOverlay)
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let line = MKPolylineRenderer(overlay: overlay)
            line.strokeColor = UIColor.purple
            line.lineWidth = 8
            return line
        }
        return MKOverlayRenderer()
    }
}

