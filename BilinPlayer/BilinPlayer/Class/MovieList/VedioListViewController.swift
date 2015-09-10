//
//  VedioListViewController.swift
//  LinlinPlayer
//
//  Created by sbx_fc on 15/9/8.
//  Copyright (c) 2015年 RG.BILIN. All rights reserved.
//

import UIKit

class VedioListViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("获取本地视频文件!")
        var theArray = [String]()
        let fileManager = NSFileManager.defaultManager()
        var error: NSError?
        var docsArray: [String] = fileManager.contentsOfDirectoryAtPath(String.documentPath, error: &error) as! [String]
        println(docsArray)
        
        for name in docsArray {
            let theName: String = name
            let stringLength = count(name) // Since swift1.2 `countElements` became `count`
            let substringIndex = stringLength - 4
            theArray.append(theName.substringToIndex(advance(name.startIndex, substringIndex)))
        }
    }
    
    
    
    private struct Contants{
        static let VedioCellIdentifier = "BLVedioCell"
    }
    
    @IBOutlet weak var vedioCollectionView: UICollectionView!
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell = vedioCollectionView?.dequeueReusableCellWithReuseIdentifier(Contants.VedioCellIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
        
        return cell;
    }
    
}
