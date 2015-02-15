//
//  UIImage+Utils.swift
//  Que hacen los diputados
//
//  Created by Andrés Pizá on 15/2/15.
//  Copyright (c) 2015 tovkal. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resize(newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
