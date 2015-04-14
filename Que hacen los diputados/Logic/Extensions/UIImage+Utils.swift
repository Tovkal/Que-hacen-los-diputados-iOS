//
//  UIImage+Utils.swift
//  Que hacen los diputados
//
//  Created by Andrés Pizá on 15/2/15.
//  Copyright (c) 2015 tovkal. All rights reserved.
//

import UIKit

extension UIImage {
    
    func cropImage(cropRect: CGRect) -> UIImage {
        var imageRef = CGImageCreateWithImageInRect(self.CGImage, cropRect)
        return UIImage(CGImage:imageRef)!
    }
}
