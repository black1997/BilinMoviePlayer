//
//  CommonUtils.swift
//  LinlinPlayer
//
//  Created by sbx_fc on 15/9/10.
//  Copyright (c) 2015年 RG.BILIN. All rights reserved.
//

import Foundation
import UIKit

class CommonUtils {
    
    class func systemVersion() ->Double{
        let version = UIDevice.currentDevice().systemVersion as NSString
        return version.doubleValue
    }
    
    static func getSizeOfText(text:String,font:UIFont)->CGSize
    {
        let font:AnyObject = font as AnyObject
        let name:NSObject = NSFontAttributeName as NSObject
        let dict = [name:font]
        let textSize: CGSize = text.sizeWithAttributes(dict)
        
        return textSize
    }
    
    
    
}