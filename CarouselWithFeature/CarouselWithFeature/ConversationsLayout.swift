//
//  ConversationsLayout.swift
//  HWChat
//
//  Created by Christian Schraga on 9/7/16.
//  Copyright © 2016 Straight Edge Digital. All rights reserved.
//

import UIKit

class CarouselLayout: UICollectionViewLayout {

    let numberOfColumns = 1
    var itemSize = CGSize(width: 100.0, height: 80.0)
    var contentWidth = CGFloat(300.0)
    let xPadding:CGFloat = 5.0
    var attributeCache = [UICollectionViewLayoutAttributes]()
    var indexHashTable = [Int]() //psuedo hash table. has a center image index for each pixel of x
    
    override func prepare() {
        super.prepare()
        let h = collectionView!.bounds.height * 0.75
        let w = h * 0.75
        itemSize = CGSize(width: w, height: h)
        
        contentWidth = CGFloat(collectionView!.numberOfItems(inSection: 0)) * (itemSize.width + xPadding)
        
        if attributeCache.isEmpty {
            var x: CGFloat = 0.0
            
            for i in 0..<collectionView!.numberOfItems(inSection: 0) {
                let localAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
                localAttributes.size = itemSize
                let y = curvedY(atX: x)
                localAttributes.frame = CGRect(x: x, y: y, width: w, height: h)
                attributeCache.append(localAttributes)
                x += w + xPadding
            }
        
            for j in 0 ... Int(contentWidth) {
                let leftIndex = Int(CGFloat(j) / (w + xPadding))
                let centerIndex = leftIndex + 1
                indexHashTable.append(centerIndex)
            }
            
        }
            
        for i in 0..<collectionView!.numberOfItems(inSection: 0) {
            let localAttributes = attributeCache[i]
            var frame = localAttributes.frame
            frame.origin.y = curvedY(atX: frame.origin.x - collectionView!.contentOffset.x + w/2)
            localAttributes.frame = frame
            attributeCache[i] = localAttributes
        }
            
        
        
        
    }
    
    fileprivate func curvedY(atX x: CGFloat) -> CGFloat {
        let minX: CGFloat = 0.0
        let width: CGFloat = collectionView!.bounds.width
        let maxX: CGFloat = minX + width
        let midX: CGFloat = minX + width/2
        let t = width > 0.0 ? x/width : 0.0
        let beg = CGPoint(x: minX, y: collectionView!.bounds.height * 0.25)
        let end = CGPoint(x: maxX, y: collectionView!.bounds.height * 0.25)
        let cp  = CGPoint(x: midX, y: collectionView!.bounds.minY)
        let y: CGFloat = (beg.y - (2.0 * cp.y) + end.y) * pow(t, 2.0) + (2.0 * cp.y - 2.0 * beg.y) * t + beg.y
        return y
    }
    
    fileprivate func pointOnCurve(t: CGFloat) -> CGPoint{
        let beg = CGPoint(x: collectionView!.bounds.minX, y: collectionView!.bounds.height * 0.8)
        let end = CGPoint(x: collectionView!.bounds.minX + contentWidth, y: collectionView!.bounds.height * 0.8)
        let cp  = CGPoint(x: collectionView!.bounds.minX + contentWidth/2, y: collectionView!.bounds.minY)
        
        let x: CGFloat = (beg.x - (2.0 * cp.x) + end.x) * pow(t, 2.0) + (2.0 * cp.x - 2.0 * beg.x) * t + beg.x
        let y: CGFloat = (beg.y - (2.0 * cp.y) + end.y) * pow(t, 2.0) + (2.0 * cp.y - 2.0 * beg.y) * t + beg.y
        
        
        return CGPoint(x: x, y: y)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributeCache[(indexPath as NSIndexPath).row]
    }
    
    override var collectionViewContentSize : CGSize {
        return CGSize(width: contentWidth, height: collectionView!.bounds.height)
    }
    
    //recalc prepare layout after each scroll
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var results = [UICollectionViewLayoutAttributes]()
        for attribute in attributeCache {
            if attribute.frame.intersects(rect){
                results.append(attribute)
            }
        }
        return results
    }
    
}
