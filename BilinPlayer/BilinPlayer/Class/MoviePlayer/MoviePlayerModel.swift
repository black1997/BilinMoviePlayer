//
//  MoviePlayerModel.swift
//  LinlinPlayer
//
//  Created by sbx_fc on 15/9/10.
//  Copyright (c) 2015年 RG.BILIN. All rights reserved.
//

import Foundation

class MoviePlayerModel {
    
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
    
}