//
//  MoviePlayerModel.swift
//  LinlinPlayer
//
//  Created by sbx_fc on 15/9/10.
//  Copyright (c) 2015年 RG.BILIN. All rights reserved.
//

import Foundation

class MoviePlayerModel {
    
    private struct SubtitlesDictonarykey{
        static let Index = "kIndex"
        static let Start = "kStart"
        static let End   = "kEnd"
        static let Text  = "kText"
    }
    
    var subtitleParts = [String:AnyObject]()

    //当前播放文件目录
    var currMovieFilePath:String{
        get{
            var localPath:String = String.documentPath + "/hh"
            localPath = localPath.stringByAppendingPathExtension("mp4")!
            return localPath
        }
    }
    
    //当前字幕文件目录
    var currSubtitlesFilePath:String?{
        get{
            var path:String = String.documentPath + "/hh1"
            path = path.stringByAppendingPathExtension("srt")!
            return path
        }
    }
    
    //根据当前播放时间查询字幕
    func searchAndShowSubtitle(time:NSTimeInterval) -> String{
        
        //当前播放到的时间
        var timeValue = Double(time)
        
        var searchPredicate:NSPredicate =  NSPredicate(format:"(%@ >= %K) AND (%@ <= %K)",
            NSNumber(double:timeValue),
            SubtitlesDictonarykey.Start,
            NSNumber(double:timeValue),
            SubtitlesDictonarykey.End)
        
        let parts = Array(subtitleParts.values)
        let resultParts = NSMutableArray(array: parts)
        resultParts.filterUsingPredicate(searchPredicate)
        
        //如果查询到符合条件的字幕
        if resultParts.count > 0
        {
            if let lastSubtiles = resultParts.lastObject! as? Dictionary<String, AnyObject>
            {
                if let singleTitle = lastSubtiles[SubtitlesDictonarykey.Text]! as? String
                {
                    return singleTitle
                }
            }
        }
        
        return ""
    }
    
    func parseRSTSubtitleString(contents:String) -> Bool{
        
        let scanner = NSScanner(string: contents)
        
        while !scanner.atEnd{
            var indexString:NSString? = nil
            scanner.scanUpToCharactersFromSet(NSCharacterSet.newlineCharacterSet(), intoString: &indexString)
            
            var startingString:NSString? = nil
            scanner.scanUpToString(" -->", intoString: &startingString)
            scanner.scanString("-->", intoString: nil)
            
            var endString:NSString? = nil
            scanner.scanUpToCharactersFromSet(NSCharacterSet.newlineCharacterSet(), intoString: &endString)
            
            var textString:NSString? = nil
            scanner.scanUpToString("\n\n", intoString: &textString)
            textString = textString?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            // Regular expression to replace tags
            var error: NSError?
            let regExp = NSRegularExpression(pattern: "[<|\\{][^>|\\^}]*[>|\\}]",
                options: NSRegularExpressionOptions.CaseInsensitive,
                error: &error)
            
            if(error != nil){
                return false
            }
            
            var textStr:String? = textString as? String
            if textStr != nil
            {
                textStr = regExp?.stringByReplacingMatchesInString(textStr!, options: NSMatchingOptions(rawValue: 0), range: NSRange(location: 0, length: count(textStr!)), withTemplate: "")
                
                var startInterval:NSTimeInterval  = MoviePlayerModel.parseRSTTimeFromString((startingString as? String)!)
                var endInterval:NSTimeInterval  = MoviePlayerModel.parseRSTTimeFromString((endString as? String)!)
                
                var indexStr:String = indexString as! String
                
                //字幕
                var subtitle = [String:AnyObject]()
                subtitle[SubtitlesDictonarykey.Index] = indexStr
                subtitle[SubtitlesDictonarykey.Start] = startInterval
                subtitle[SubtitlesDictonarykey.End] = endInterval
                subtitle[SubtitlesDictonarykey.Text] = textStr
                subtitleParts[indexStr] = subtitle
            }
        }
        
        return true
    }
    
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