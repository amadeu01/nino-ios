//
//  MyDayCollectionViewLayout.swift
//  ninoEscola
//
//  Created by Carlos Eduardo Millani on 12/1/15.
//  Copyright © 2015 Alfredo Cavalcante Neto. All rights reserved.
//

import UIKit

protocol MyDayCollectionViewLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForBoxAtIndexPath indexPath: NSIndexPath, withWidth: CGFloat) -> CGFloat
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
}

class MyDayCollectionViewLayout: UICollectionViewLayout {
    
    var delegate: MyDayCollectionViewLayoutDelegate!
    
    var numberOfColumns = 2
    var cellPadding: CGFloat = 10.0
    
    private var cache = [UICollectionViewLayoutAttributes]()
    //becke
    private var footerAttributes = [NSIndexPath:UICollectionViewLayoutAttributes]()
    
    private var contentHeight: CGFloat  = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
    }
    
    
    override func prepareLayout() {
        collectionView?.delaysContentTouches = false
        //clear the cache
        self.cache.removeAll()
        self.footerAttributes.removeAll()
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth )
        }
        var column = 0
        var yOffset = [CGFloat](count: numberOfColumns, repeatedValue: cellPadding)
        
        for item in 0 ..< collectionView!.numberOfItemsInSection(0) {
            
            let indexPath = NSIndexPath(forItem: item, inSection: 0)
            
            let width = columnWidth - cellPadding * 2
            let boxHeight = delegate.collectionView(collectionView!, heightForBoxAtIndexPath: indexPath, withWidth:width)
            let annotationHeight = delegate.collectionView(collectionView!, heightForAnnotationAtIndexPath: indexPath, withWidth: width)
            let height = boxHeight + annotationHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = CGRectInset(frame, cellPadding, 0)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, CGRectGetMaxY(frame))
            yOffset[column] = yOffset[column] + height
            
            if yOffset[column] >= (column == 1 ? yOffset[0] : yOffset[1]) {
                column = column >= (numberOfColumns - 1) ? 0 : ++column
            }
        }
        
        let footerIndex = NSIndexPath(forItem: collectionView!.numberOfItemsInSection(0) + 1, inSection: 0)
        let footerCellAtt = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withIndexPath: footerIndex)
//        collectionView?.supplementaryViewForElementKind(, atIndexPath: )
        self.footerAttributes[footerIndex] = footerCellAtt
        footerCellAtt.frame = CGRect(x: 0, y: yOffset[0], width: self.contentWidth, height: 40)
        
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if CGRectIntersectsRect(attributes.frame, rect) {
                layoutAttributes.append(attributes)
            }
        }
        for attribute in footerAttributes {
            layoutAttributes.append(attribute.1)
        }
        return layoutAttributes
    }
    
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return self.footerAttributes[indexPath]
    }
    
}
