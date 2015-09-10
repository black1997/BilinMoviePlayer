//
//  SubtitleUntils.swift
//  LinlinPlayer
//
//  Created by sbx_fc on 15/9/10.
//  Copyright (c) 2015年 RG.BILIN. All rights reserved.
//

import Foundation

class SubtitleUntils {
    
//    static func parseString(text:String)->[String:AnyObject]
//    {
////        
//    }
    
    static func parseRSTTimeFromString(timeString:String) -> Double
    {
        var scanner = NSScanner(string: timeString)
        var h:Int32 = 0
        var m:Int32 = 0
        var s:Int32 = 0
        var c:Int32 = 0
        
        scanner.scanInt(&h)
        scanner.scanString(":", intoString: nil)
        scanner.scanInt(&m)
        scanner.scanString(":", intoString: nil)
        scanner.scanInt(&s)
        scanner.scanString(",", intoString: nil)
        scanner.scanInt(&c)
        
        var temp:Int32 = (h * 3600) + m * 60 + s
        var timeValue:Double = Double(temp) + (Double(c) / 1000.0)
        return timeValue
    }
    
}