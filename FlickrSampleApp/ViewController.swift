//
//  ViewController.swift
//  FlickrSampleApp
//
//  Created by KimMinki on 2017. 2. 11..
//  Copyright © 2017년 potenn. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class ViewController: UIViewController {

    
    @IBOutlet weak var flickrImageView: UIImageView!
    
    @IBOutlet weak var timeIntervalSlider: UISlider!
    
    @IBOutlet weak var timeIntervalLabel: UILabel!
    
    var canContinueLoad : Bool = true
    var canShowImage : Bool = false
    var count : Int = 0
    
    var idx : Int = 0
    var flickrImageArray : [String] = []
    
    let serverURL = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
    
    var isTimerStart : Bool = false
    
    
    @IBAction func timeIntervalSliderChanged(_ sender: Any) {
        let currentValue = Int(self.timeIntervalSlider.value)
        self.timeIntervalLabel.text = "\(currentValue) Seconds"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentValue = Int(self.timeIntervalSlider.value)
        self.timeIntervalLabel.text = "\(currentValue) Seconds"
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func startButtonClicked(_ sender: Any) {
        
        self.playImagesOfFlickr()
        
    }
    
    func playImagesOfFlickr() -> Void{
        let timerInvalidate: Bool = false
        
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            while !timerInvalidate {
                
                DispatchQueue.global(qos: .background).async(execute: {() -> Void in
                    
                    print("Thread Global")
                    if(self.idx >= self.count){
                        print("refreshFlickrImage")
                        self.idx = 0
                        self.canContinueLoad = true
                        self.refreshFlickrImage()
                    }
                    
                    DispatchQueue.main.async {
                        
                        print("Thread Main \(self.idx)")
                        if self.canShowImage{
                            if self.count > self.idx{
                                
                                self.flickrImageView.sd_setImage(with: URL(string: self.flickrImageArray[self.idx])!)
                                self.idx = self.idx + 1
                                
                            }
                        }else{
                            print("Not Shown yet")
                        }
                        
                        
                    }
                    
                })
                
                
                Thread.sleep(forTimeInterval: TimeInterval(self.timeIntervalSlider.value))
                print("Thread Sleep")
                
            }
        })
    }
    
    func refreshFlickrImage() -> Void{
        
        if canContinueLoad{
            
            Alamofire.request(serverURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON{
                
                response in switch response.result {
                    
                case .success(let JSON):
                    
                    let response = JSON as! NSDictionary
                    let flickrDataArray =  response.object(forKey: "items") as! NSArray
                    
                    if self.count == self.flickrImageArray.count{
                        self.flickrImageArray.removeAll()
                    }
                    
                    self.count = flickrDataArray.count
                    print("Items Count: \(flickrDataArray.count)")
                    
                    for element in flickrDataArray{
                        
                        let json = element as! NSDictionary
                        
                        let mediaImageArray = json.object(forKey: "media") as! NSDictionary
                        
                        let mediaDataURL = mediaImageArray.object(forKey: "m") as? String
                        if mediaDataURL != nil{
                            
                            self.flickrImageArray.append(mediaDataURL!)
                            print(mediaDataURL!)
                            
                            
                        }
                    }
                    
                    self.idx = 0
                    self.count = self.flickrImageArray.count
                    self.canContinueLoad = false
                    self.canShowImage = true
                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

