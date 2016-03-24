//
//  WeatherViewController.swift
//  newxyt
//
//  Created by 谭钧豪 on 16/2/2.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit
import CoreLocation
import AFNetworking



class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    let locationmanager = CLLocationManager()
    let weathersource = "OpenWeatherMap"
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var temperature: UILabel!
    
    var lat:CLLocationDegrees?
    var lon:CLLocationDegrees?
    var country = "CN"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setdate()
        
        
        locationmanager.delegate = self
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest
        locationmanager.requestAlwaysAuthorization()
        locationmanager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }
    
    func setdate(){
        let curdate = NSDate()
        let timeFormatter = NSDateFormatter()
        if country == "CN"{
            timeFormatter.dateFormat = "yyyy年MM月dd日"
        }else{
            timeFormatter.dateFormat = "dd-MM-yyyy"
        }
        date.text = timeFormatter.stringFromDate(curdate) as String
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            lat = location.coordinate.latitude
            lon = location.coordinate.longitude
            self.updateWeatherInfo(location.coordinate.latitude, longitude: location.coordinate.longitude)
            locationmanager.stopUpdatingLocation()
        }
        
    }
    
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        setdate()
        locationmanager.startUpdatingLocation()
    }
    
    func updateWeatherInfo(latitude:CLLocationDegrees, longitude:CLLocationDegrees){
        let manager = AFHTTPRequestOperationManager()
        let url = "http://api.openweathermap.org/data/2.5/weather"
        let params = ["lat":latitude,"lon":longitude,"appid":"6516f3c8af1e6d6a66d05b891a3530f6"]
        manager.GET(url, parameters: params,
            success: {
            (operation:AFHTTPRequestOperation!,responseObject: AnyObject!) in
                self.updateUIInfo(responseObject as! NSDictionary)
            },
            failure: {
            (operation:AFHTTPRequestOperation?,error: NSError!) in
                print("Error:"+error.localizedDescription)
            }
        )
    }
    
    func setcityname(){
        let manager = AFHTTPRequestOperationManager()
        //百度地图反编译经纬度获取城市名
        let key = "fNV2qOKKxARhR1Q7jD82jGZt"
        let location = "\(lat!),\(lon!)"
        
        let url = "http://api.map.baidu.com/geocoder/v2/"
        let params = ["mcode":"com.jxustnc.newxyt","ak":key,"location":location,"output":"json"]
        manager.GET(url, parameters: params,
            success: {
                (operation:AFHTTPRequestOperation!,responseObject: AnyObject!) in
                let jsonresult = responseObject as! NSDictionary
                let component = jsonresult["result"]!["addressComponent"] as! NSDictionary
                self.city.text = String(component["city"]!)
            },
            failure: {
                (operation:AFHTTPRequestOperation?,error: NSError!) in
                print("Error:"+error.localizedDescription)
                self.city.text = "获取城市名字出错"
            }
        )
    }
    
    
    
    func setchineseweather(weathername:String){
        let manager = AFHTTPRequestOperationManager()
        //百度翻译API
        let appid = "20160203000010824"
        let salt = "1435660288"
        let transkey = "XOIVTtBjZdaOsoXvoIKv"
        
        let sign = appid+weathername+salt+transkey
        let sign_md5 = sign.md5()
        
        let url = "http://api.fanyi.baidu.com/api/trans/vip/translate/"
        let params = ["q":weathername,
            "from":"en",
            "to":"zh",
            "appid":appid,
            "salt":salt,
            "sign":sign_md5
        ]
        manager.GET(url, parameters: params,
            success: {
                (operation:AFHTTPRequestOperation!,responseObject: AnyObject!) in
                let jsonresult = responseObject as! NSDictionary
                if let result = jsonresult["trans_result"]?[0]?["dst"] as? String{
                    self.weather.text = result
                }
            },
            failure: {
                (operation:AFHTTPRequestOperation?,error: NSError!) in
                print("Error:"+error.localizedDescription)
            }
        )
    }
    
    func updateUIInfo(jsonResult:NSDictionary!){
        if let tempResult = (jsonResult["main"]?["temp"]) as? Double{
            var temperature:Double
            country = (jsonResult["sys"]?["country"] as? String)!
            if (country == "US"){
                temperature = ((tempResult - 273.15)*1.8)+32
                self.temperature.text = String(format: "%.2f",temperature)+"°F (\(String(format: "%.2f",tempResult - 273.15)+"°C"))"
            }else{
                temperature = tempResult - 273.15
                self.temperature.text = String(format: "%.2f",temperature)+"°C"
            }
            
            if (country == "CN"){
                setcityname()
                if let weathername = jsonResult["weather"]?[0]?["description"] as? String{
                    weather.text = weathername
                    setchineseweather(weathername)
                }else{
                    weather.text = "无法获取当前气象"
                }
            }else{
                setdate()
                self.city.text = jsonResult["name"] as? String
                if let weathername = jsonResult["weather"]?[0]?["description"] as? String{
                    weather.text = weathername
                }else{
                    weather.text = "Can not get the weather."
                }
            }
            
            
            
        }else{
            print("无法获取数据")
        }
    }
    
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
