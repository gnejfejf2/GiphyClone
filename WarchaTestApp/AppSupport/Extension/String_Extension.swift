//
//  String_Extension.swift
//  WarchaTestApp
//
//  Created by Hwik on 2022/02/21.
//

import UIKit

extension String{
    
    func getCGFloat() -> CGFloat {
        
        return CGFloat(NSString(string: self).floatValue)
    }
    
}
