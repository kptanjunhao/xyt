//
//  MoreLayout.swift
//  newxyt
//
//  Created by 谭钧豪 on 16/2/2.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

class MoreLayout: UICollectionViewLayout {
    
    override func collectionViewContentSize() -> CGSize {
        return CGSizeMake((collectionView?.bounds.width)!, (collectionView?.bounds.height)!)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArray = [UICollectionViewLayoutAttributes]()
        let cellCount = self.collectionView?.numberOfItemsInSection(0)
        for i in 0..<cellCount!{
            let indexPath = NSIndexPath(forItem: i, inSection: 0)
            let attributes = self.layoutAttributesForItemAtIndexPath(indexPath)
            attributesArray.append(attributes!)
        }
        return attributesArray
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        let lineSpacing = 30
        
        let CellSide:CGFloat = 150
        
        let insets = UIEdgeInsets(top: 28, left: 26, bottom: 20, right: 26)
        
        let line:Int = indexPath.item
        
        let lineOriginY = (CellSide-50) * CGFloat(line) + CGFloat(lineSpacing * line) + 20
        
        let rightX = (collectionView?.bounds.size.width)! - CellSide - insets.right
        
        switch(indexPath.item){
            case 0:
                attribute.frame = CGRectMake(insets.left, lineOriginY, CellSide, CellSide)
            case 1:
                attribute.frame = CGRectMake(rightX, lineOriginY, CellSide, CellSide)
            case 2:
                attribute.frame = CGRectMake(insets.left, lineOriginY, CellSide, CellSide)
            case 3:
                attribute.frame = CGRectMake(rightX, lineOriginY, CellSide, CellSide)
            default:
                break
        }
        
        return attribute
    }
    
    
}
