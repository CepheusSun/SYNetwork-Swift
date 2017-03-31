//
//  SYLocationTool.swift
//  SwiftLive
//
//  Created by sunny on 2017/3/23.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import UIKit
import CoreLocation

class SYLocationTool: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var myLatitude: CLLocationDegrees = CLLocationDegrees(116.404284)
    var myLongitude: CLLocationDegrees = CLLocationDegrees(39.906585)
    var locality = "北京市"
    var area = "北京"
    var isoCountryCode = "中国"
    
    static let shared = SYLocationTool()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    public func gps_info_string() -> String! {
        return "\(myLatitude)%2C\(myLongitude)"
    }
    
    public func loc_info_string() -> String! {
        return "\(isoCountryCode),\(area),\(locality)"
    }
}

// MARK: - CLLocationManagerDelegate
extension SYLocationTool {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) in
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")

            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    
}

extension SYLocationTool {
    func displayLocationInfo(_ placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            //get data from placemark
            if containsPlacemark.locality != nil {
                locality =  containsPlacemark.locality!
            }
            
            if containsPlacemark.isoCountryCode != nil {
                isoCountryCode =  containsPlacemark.isoCountryCode!
            }
            
            if containsPlacemark.administrativeArea != nil {
                area =  containsPlacemark.administrativeArea!
            }
            
            myLongitude = (containsPlacemark.location!.coordinate.longitude)
            myLatitude = (containsPlacemark.location!.coordinate.latitude)
        }
    }
}
