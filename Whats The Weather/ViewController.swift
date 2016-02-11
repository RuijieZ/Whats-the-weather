//
//  ViewController.swift
//  Whats The Weather
//
//  Created by Ruijie Zhang on 2015-08-08.
//  Copyright (c) 2015 Ruijie Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var userCity: UITextField!
    
    @IBAction func findWeather(sender: AnyObject)
    {
        var cityName = userCity.text.stringByReplacingOccurrencesOfString(" ", withString: "-")
        
        var ifError = false
        
        var weather = ""
        
        var url = NSURL(string: "http://www.weather-forecast.com/locations/" + cityName + "/forecasts/latest")
        
        if url == nil
        {
            ifError = true
        }
        else
        {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler:
                {(data,response, error) -> Void in
                    
                    if (error == nil)
                    {
                        self.result.text = "wheater"
                        
                        var urlContent = NSString(data: data, encoding: NSUTF8StringEncoding)
                        
                        println(urlContent)
                        
                        var urlContentArray = urlContent?.componentsSeparatedByString("<span class=\"phrase\">") as! [String]
                        
                        if urlContentArray.count > 1
                        {
                            
                            var weatherArray = urlContentArray[1].componentsSeparatedByString("</span>")
                            
                            weather = weatherArray[0] as String
                            
                            weather = weather.stringByReplacingOccurrencesOfString( "&deg;", withString: "º")
                            
                        }
                        else
                        {
                            ifError = true
                        }
                    }
                    else
                    {
                        ifError = true
                    }
                    
                    dispatch_async(dispatch_get_main_queue())
                        {
                            if(ifError)
                            {
                                self.showError()
                                
                            }
                            else
                            {
                                self.result.text = weather
                            }
                            
                    }
                    
                    
            })
            task.resume()
        }

    }
    
    func showError()
    {
        result.text = "We could not find weather for " + userCity.text + ". Please check your spelling and internet connection"
    }
    
    @IBOutlet var result: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent){
        self.view.endEditing(true)
    }
}

