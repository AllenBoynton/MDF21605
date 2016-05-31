//
//  ViewController.swift
//  GrandCentralDispatch
//
//  Created by Allen Boynton on 5/14/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Outlet collection array of webviews
    @IBOutlet var images: [UIImageView]!
    
    // Local variables
    var scenes: [String] = []
    
    var mySerialQueue: dispatch_queue_t!
    
    var myConcurrentQueue: dispatch_queue_t!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Array of URL's to keep code clean -> Strings are at bottom of page
        scenes = [scene1, scene2, scene3, scene4, scene5, scene6, scene7, scene8]
        
        mySerialQueue = dispatch_queue_create("uniqueString", DISPATCH_QUEUE_SERIAL)
        
        myConcurrentQueue = dispatch_queue_create("quickerUniqueString", DISPATCH_QUEUE_CONCURRENT)
    }

    // Action button outlets
    @IBAction func regular(sender: UIButton) {
    
        //Perform Long Running Task On Main Thread (Thread Blocking)
        for (image, city) in [(images[0], scenes[0]), (images[1], scenes[1]), (images[2], scenes[2]), (images[3], scenes[3]), (images[4], scenes[4]), (images[5], scenes[5]), (images[6], scenes[6]), (images[7], scenes[7])] {
            
            if let myURL = NSURL(string: city) {
                
                let urlImage = image
                
                if let data = NSData(contentsOfURL: myURL) {
                    
                    urlImage.image = UIImage(data: data)
                }
            }
        }
    }
    
    // Action to download images by serial
    @IBAction func serial(sender: UIButton) {
        
        // Version: 3 -> USE THIS MOST EFFICIENT VERSION
        // This produces 4 jobs ----- each dispatch is 1 job (3 jobs, times each protocol = 6 jobs total)
        for (image, city) in [(images[0], scenes[0]), (images[1], scenes[1]), (images[2], scenes[2]), (images[3], scenes[3]), (images[4], scenes[4]), (images[5], scenes[5]), (images[6], scenes[6]), (images[7], scenes[7])] {
            
            // Dispatch to new SERIAL QUEUE
            dispatch_async(mySerialQueue, {
                
                if let myURL = NSURL(string: city) {
                    
                    let urlImage = image
                    
                    if let data = NSData(contentsOfURL: myURL) {
                        
                        // Dispatch back out to main queue
                        dispatch_sync(dispatch_get_main_queue(), {
                            
                            urlImage.image = UIImage(data: data)
                        })
                    }
                }
            })
        }
    }
    
    // Action to download images concurrently
    @IBAction func concurrent(sender: UIButton) {
        
        for (image, city) in [(images[0], scenes[0]), (images[1], scenes[1]), (images[2], scenes[2]), (images[3], scenes[3]), (images[4], scenes[4]), (images[5], scenes[5]), (images[6], scenes[6]), (images[7], scenes[7])] {
            
            // Dispatch to new CONCURRENT QUEUE
            dispatch_async(myConcurrentQueue, {
                
                if let myURL = NSURL(string: city) {
                    
                    let urlImage = image
                    
                    if let data = NSData(contentsOfURL: myURL) {
                        
                        // Dispatch back out to main queue
                        dispatch_sync(dispatch_get_main_queue(), {
                            
                            urlImage.image = UIImage(data: data)
                        })
                    }
                }
            })
        }
    }
    
    @IBAction func clearAllViews(sender: UIButton) {
        for image in images {
            image.image = nil
        }
    }


// Url's assigned to constants
let scene1 = "http://www.planwallpaper.com/static/images/hd-beach-wallpapers-1080p.jpg"
let scene2 = "http://www.planwallpaper.com/static/images/hd-wallpapers_1080p.jpg"
let scene3 = "http://wallpaperhdwide.com/wp-content/gallery/background-wallpapers-download/Download-Beach-Resort-Background-Images-HD-Wallpaper.jpg"
let scene4 = "http://wallpapercave.com/wp/EeDOQty.jpg"
let scene5 = "https://wallpaperscraft.com/image/new_york_city_streets_landscape_skyscraper_cityscape_25412_1920x1080.jpg"
let scene6 = "http://wallpapercave.com/wp/GJOAPe0.jpg"
let scene7 = "http://www.silenceoflight.com/_include/img/slider-images/image03.jpg"
let scene8 = "http://p1.pichost.me/i/75/1999394.jpg"
}
