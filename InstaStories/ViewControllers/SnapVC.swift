//
//  SnapVC.swift
//  InstaStories
//
//  Created by Sualp DANACI on 9.08.2024.
//

import UIKit
import ImageSlideshow
import ImageSlideshowKingfisher


class SnapVC: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var selectedSnap: Snap?
        var inputArray = [KingfisherSource]()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
        
            if let snap = selectedSnap {
            
                timeLabel.text = "Time Left: \(snap.timeDifference)"
                
               
                for imageUrl in snap.imageUrlArray {
                    if let source = KingfisherSource(urlString: imageUrl) {
                        inputArray.append(source)
                    }
                }
                
                
                let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.9))
                imageSlideShow.backgroundColor = UIColor.white
                
                
                let pageIndicator = UIPageControl()
                pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
                pageIndicator.pageIndicatorTintColor = UIColor.black
                imageSlideShow.pageIndicator = pageIndicator
                
 
                imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
                
              
                imageSlideShow.setImageInputs(inputArray)
                
              
                self.view.addSubview(imageSlideShow)
                
             
                self.view.bringSubviewToFront(timeLabel)
            }
            
           
            timeLabel.frame = CGRect(x: 20, y: 50, width: 200, height: 40)
            
       
            timeLabel.backgroundColor = UIColor.white
            timeLabel.textColor = UIColor.black
        }
    }
