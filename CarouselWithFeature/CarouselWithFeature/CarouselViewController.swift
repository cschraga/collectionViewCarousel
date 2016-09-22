//
//  ViewController.swift
//  CarouselWithFeature
//
//  Created by Christian Schraga on 9/22/16.
//  Copyright © 2016 Straight Edge Digital. All rights reserved.
//

import UIKit


protocol CarouselViewControllerDataSource {
    func carouselViewControllerNumberOfFeatures(_ viewController: CarouselViewController) -> Int
    func carouselViewControllerDataAtIndex(_ viewController: CarouselViewController, index: Int) -> CarouselData
}

protocol CarouselViewControllerDelegate {
    func carouselViewControllerClicked(_ viewController: CarouselViewController, clickedIndex index: Int)
    //func carouselViewControllerNewFeatureInCenter(_ viewController: CarouselViewController, centerIndex index: Int)
}

struct CarouselData {
    var image: UIImage
    var title: String
    var index: Int
    
    init(){
        self.image = UIImage()
        self.title = "No Title"
        self.index = -1
    }
}

class CarouselViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //UI
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //color scheme
    var backgroundColor: UIColor = UIColor.black
    var shadowColor: UIColor = UIColor.darkGray
    var textColor: UIColor = UIColor.white
    var highlightColor: UIColor = UIColor.yellow
    var clickColor: UIColor = UIColor.blue
    var maskColor: UIColor  = UIColor(white: 1.0, alpha: 0.62)
    var detailsLabelAlpha :CGFloat = 0.50
    
    //formatting
    fileprivate var carouselRelativeY: CGFloat = 0.75
    fileprivate var fontSize: CGFloat = 14.0
    fileprivate var fontName = "TradeGothicLTStd-Bd2"

    
    //delegates
    var dataSource: CarouselViewControllerDataSource?
    var delegate: CarouselViewControllerDelegate?

    //data
    let reuseIdentifier = "carouselCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set data delegate
        dataSource = CarouselDataManager.sharedInstance
        
        //detail button configuration
        detailButton.setTitle("DETAILS \n v", for: .normal)
        detailButton.setTitle("DETAILS \n ^", for: .selected)
        detailButton.setTitleColor(textColor, for: .normal)
        detailButton.setTitleColor(textColor, for: .selected)
        detailButton.setTitleColor(clickColor, for: .highlighted)
        detailButton.titleLabel?.numberOfLines = 2
        detailButton.titleLabel?.textAlignment = .center
        detailButton.isSelected = true
        detailButton.addTarget(self, action: #selector(CarouselViewController.detailButtonTouchUp(_:)), for: .touchUpInside)
        
        //set collection view
        collectionView.register(UINib(nibName: "CarouselCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.backgroundColor = UIColor.clear
    }
    
    
    //MARK: SELECTORS
    func detailButtonTouchUp(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        detailTextView.alpha = sender.isSelected ? detailsLabelAlpha : 0.0
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = collectionView.contentOffset.x
        if let carouselLayout = collectionView!.collectionViewLayout as? CarouselLayout {
            let intOffset = Int(offset)
            if intOffset >= 0 && intOffset < carouselLayout.indexHashTable.count {
                let centerIndex = carouselLayout.indexHashTable[intOffset]
                print("offset: \(offset)")
                if let dataSource = self.dataSource {
                    let image = dataSource.carouselViewControllerDataAtIndex(self, index: centerIndex).image
                    mainImageView.image = image
                }
            }
        }
    }
    
    //MARK: COLLECTION VIEW DATASOURCE
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var result = 0
        if let dataSource = dataSource {
            result = dataSource.carouselViewControllerNumberOfFeatures(self)
        }
        return result
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let myCell = cell as? CarouselCollectionViewCell{
            if let dataSource = dataSource {
                let data = dataSource.carouselViewControllerDataAtIndex(self, index: indexPath.row)
                myCell.image = data.image
                myCell.text  = data.title
                myCell.tag   = data.index
            }
            cell = myCell
        }
        
        return cell
    }
    
    //MARK: COLLECTION VIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if let myCell = cell as? CarouselCollectionViewCell {
            delegate?.carouselViewControllerClicked(self, clickedIndex: indexPath.row)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

