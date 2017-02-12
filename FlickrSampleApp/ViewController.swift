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

    // MARK: - IBOutlet Object
    
    @IBOutlet weak var flickrImageView: UIImageView!
    
    @IBOutlet weak var timeIntervalSlider: UISlider!
    
    @IBOutlet weak var timeIntervalLabel: UILabel!
    

    // MARK: - IBAction Method
    @IBAction func timeIntervalSliderChanged(_ sender: Any) {
        let currentValue = Int(self.timeIntervalSlider.value)
        self.timeIntervalLabel.text = "\(currentValue) Seconds"
    }
    
    // MARK: - Variable
    
    /*
     if you use all images from feeds of photos_public and canContinueLoad is true, you can get new images from feeds of photos_public.
     */
    var canContinueLoad : Bool = true
    
    /*
    if flickrImageArray has no data or is not ready yet, this canShowImage variable value is false
     */
    var canShowImage : Bool = false
    
    /*
     Num of flickrImageArray
     */
    var count : Int = 0
    
    /*
    index of flickrImageArray
     */
    var idx : Int = 0
    
    /* 
     image Array for Flickr Images
    */
    var flickrImageArray : [String] = []
    
    
    /*
     Feeds of photos_public API
     Import 20 data for the current date (2017. 2. 12)
     */
    let serverURL = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
    
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentValue = Int(self.timeIntervalSlider.value)
        self.timeIntervalLabel.text = "\(currentValue) Seconds"
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    // MARK: - Start Digital Photo Album
    @IBAction func startButtonClicked(_ sender: Any) {
        
        self.playImagesOfFlickr(showAnimationFunction: showAnimation, hideAnimationFunction: hideAnimation)
    }
    
    // MARK: - Animation
    
    /*
     You can write animation if you want to show using other animations
     default : Fade-In
     */
    func showAnimation() {
        
        //Fade in
        UIView.animate(withDuration: 2.0, animations: {() -> Void in
            
            self.flickrImageView.alpha = 1.0
            self.idx = self.idx + 1
            
        }, completion: {(_ finished: Bool) -> Void in
            print("Show Image")
        })
        
    }
    
    /*
     You can write animation if you want to hide using other animations
     default : Fade-Out
     */
    func hideAnimation() {
        //Fade out
        UIView.animate(withDuration: 2.0, animations: {() -> Void in
            print("Fade out Index \(self.index)");
            self.flickrImageView.alpha = 0.0
        }, completion: { _ in
            print("Hide Image Animation Completed")
        })
    }
    
    // MARK: - Show Image Start
    
    /**
     show Images from Flickr API.
     
     - param showAnimationFunction : func task1()
     - param hideAnimationFunction : func task2()
     
     - return : void
     */

    func playImagesOfFlickr(showAnimationFunction:@escaping (Void)->Void, hideAnimationFunction:@escaping (Void)->Void){
        
        let timerInvalidate: Bool = false
        
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            
            while !timerInvalidate {
                
                DispatchQueue.global(qos: .background).async(execute: {() -> Void in
                    
                    print("Thread Global Background")
                    
                    /*
                     use all Images in flickrImageArray, so
                     you must get new images from Flickr Images.
                     */
                    if self.idx >= self.count{
                        
                        print("RefreshFlickrImage")
                        self.idx = 0
                        self.canContinueLoad = true
                        self.refreshFlickrImage()
                    }
                    
                    DispatchQueue.main.async {
                        
                        if self.canShowImage{
                            
                            if self.count > self.idx{
                                
                                self.flickrImageView.sd_setImage(with: URL(string: self.flickrImageArray[self.idx])!, completed:{ (image, error, cacheType, imageURL) in
                                    
                                    /*
                                     completed get Image from serverURL, Perform Show Animation.
                                     */
                                    showAnimationFunction()
                                })
                            }
                        }else{
                            print("Not Ready for Showing Images")
                        }
                    }
                })
                
                print("Global Thread Sleep \(self.timeIntervalSlider.value) seconds")
                /*
                 Thread.sleep plus 4.0
                 Because each Animation(Show, Hide) has 1.0 seconds.
                 (show : 2 seconds, hide : 2 seconds)
                 */
                Thread.sleep(forTimeInterval: TimeInterval(self.timeIntervalSlider.value + 4.0))
                
                //Fade out
                hideAnimationFunction()
            }
        })
    }
    
    

    // MARK: - Get images from serverURL(https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1)
    /**
     
     get new Images from Flickr API.
     
     - param : void

     - return : void
     
     */
    func refreshFlickrImage() {
        
        if canContinueLoad{
            
            Alamofire.request(serverURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON{
                
                response in switch response.result {
                    
                case .success(let JSON):
                    
                    let response = JSON as! NSDictionary
                    let flickrDataArray = response.object(forKey: "items") as! NSArray
                    
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
    
    // MARK: - didReceiveMemoryWarning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

