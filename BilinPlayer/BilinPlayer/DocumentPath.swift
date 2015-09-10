//
//  DocumentPath.swift
//  LinlinPlayer
//
//  Created by sbx_fc on 15/9/8.
//  Copyright (c) 2015年 RG.BILIN. All rights reserved.
//

import Foundation

extension String{
    static var rootPath: String {
        get {
            return NSHomeDirectory()
        }
    }
    
    static var documentPath: String {
        get {
            return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        }
    }
    
    static var libraryPath: String {
        get {
            return NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0] as! String
        }
    }
    
    static var cachePath: String {
        get {
            return NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0] as! String
        }
    }
}