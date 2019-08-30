//
//  String.swift
//  ArkusnexusTest
//
//  Created by Rogelio Contreras Velázquez on 28/08/19.
//  Copyright © 2019 Rogelio Contreras Velázquez. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func filterNumber() -> String {
        let filteredScalars = unicodeScalars.filter{
            CharacterSet.decimalDigits.contains($0)
        }
        return String( String.UnicodeScalarView(filteredScalars) )
    }
}

extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 0, y: 1)
    }
    
    func createGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}

extension UINavigationBar {
    
    func setGradientBackground(colors: [UIColor] = [.lightGray, .white, .white, .white, .white] ) {
        
        var updatedFrame = bounds
        updatedFrame.size.height += self.frame.origin.y
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        
        setBackgroundImage(gradientLayer.createGradientImage(), for: UIBarMetrics.default)
    }
}
