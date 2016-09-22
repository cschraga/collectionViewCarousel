//
//  CarouselDataManager.swift
//  CarouselWithFeature
//
//  Created by Christian Schraga on 9/22/16.
//  Copyright © 2016 Straight Edge Digital. All rights reserved.
//

import UIKit

class CarouselDataManager: NSObject, CarouselViewControllerDataSource {
    
    class var sharedInstance: CarouselDataManager {
        get{
            return sharedDataManager
        }
    }
    
    func carouselViewControllerNumberOfFeatures(_ viewController: CarouselViewController) -> Int {
        return 16
    }
    
    func carouselViewControllerDataAtIndex(_ viewController: CarouselViewController, index: Int) -> CarouselData {
        var result = CarouselData()
        if let image = UIImage(named: "puppy\(index)"){
            result.image = image
        }
        result.index = index
        result.title = "Puppy Number \(index)"
        return result
    }
    
}

let sharedDataManager = CarouselDataManager()
