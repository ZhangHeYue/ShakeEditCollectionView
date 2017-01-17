//
//  ShakeLayout.swift
//  ShakeEditCollectionView
//
//  Created by 张和悦 on 2017/1/11.
//  Copyright © 2017年 com.ZHY. All rights reserved.
//

import UIKit

class ShakeLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attrs = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        var lastXOffset: CGFloat = 0
        var lastYCenter: CGFloat = 0
        for attr in attrs {
            if attr.center.y != lastYCenter {
                lastYCenter = attr.center.y
                lastXOffset = 0
            }
            attr.frame.origin.x = lastXOffset
            lastXOffset = attr.frame.origin.x + attr.frame.size.width + minimumInteritemSpacing
        }
        return attrs
    }
    
}
