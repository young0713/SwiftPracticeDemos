//
//  FindMyLocationViewController.swift
//  SwiftDemos
//
//  Created by wanzhaoyang on 2018/2/10.
//  Copyright © 2018年 ksyun. All rights reserved.
//

import UIKit
import CoreLocation

class FindMyLocationViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var findLocationBtn: UIButton!
    var locationManager : CLLocationManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Find My Location"
        
        findLocationBtn.layer.cornerRadius = 22.0
        findLocationBtn.layer.masksToBounds = true
    }
    
    private func startLocation() {
        
        if CLLocationManager.locationServicesEnabled() {
            
            if locationManager == nil {
                locationManager = CLLocationManager.init()
                locationManager?.delegate = self
                locationManager?.requestWhenInUseAuthorization()
                locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
                locationManager?.distanceFilter = 100.0
            }
            locationManager?.startUpdatingLocation()
        }
    }

    @IBAction func onFindLocationAction(_ sender: Any) {
        startLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager?.stopUpdatingLocation()
        
        if locations.count == 0 {
            locationLabel.text = "定位失败"
            return;
        }
        let currentLocation : CLLocation = locations.last!
        let geoCoder = CLGeocoder.init()
        
        weak var weakself = self
        geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: { (placemarks: [CLPlacemark]!, error: Error?) in
            
            if error != nil || placemarks.count == 0 {
                weakself?.locationLabel.text = "定位失败"
                return;
            }
            
            let placemark = placemarks[0]
            weakself?.locationLabel.text = placemark.country! + placemark.locality! + placemark.subLocality!;
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationLabel.text = "定位失败"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
