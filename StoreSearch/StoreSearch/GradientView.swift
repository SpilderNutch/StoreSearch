//
//  GradientView.swift
//  StoreSearch
//
//  Created by 宇 欧阳 on 16/6/13.
//  Copyright © 2016年 Rocky. All rights reserved.
//

import UIKit


class GradientView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        
        autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clearColor()
        
        autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
        
    }
    
    
    override func drawRect(rect: CGRect) {
        
        let components :[CGFloat] = [0,0,0,0.3,0,0,0,0.7]
        let locations :[CGFloat] = [0,1]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2)
        
        let x = CGRectGetMinX(bounds)
        let y = CGRectGetMinY(bounds)
        
        let point = CGPoint(x: x, y: y)
        let radius = max(x, y)
        
        let content = UIGraphicsGetCurrentContext()
        CGContextDrawRadialGradient(content, gradient, point, 0, point, radius, .DrawsAfterEndLocation)
        
        
    }
    
    
    
    
}
