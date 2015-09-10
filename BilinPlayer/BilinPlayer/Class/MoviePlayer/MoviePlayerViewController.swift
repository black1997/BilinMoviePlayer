//
//  MoviePlayerViewController.swift
//  LinlinPlayer
//
//  Created by sbx_fc on 15/9/8.
//  Copyright (c) 2015年 RG.BILIN. All rights reserved.
//

import UIKit
import MediaPlayer

class MoviePlayerViewController: UIViewController {
    
    //
    var model = MoviePlayerModel()
    
    //播放器
    var moviePlayer:MPMoviePlayerController?
    
    //当前的字幕文本
    var subtitlesText:String? {
        didSet{
            subtitleLabel?.text = subtitlesText
            updateLabelConstraints()
        }
    }
    var subtitleLabel:UILabel?
    

    
    //加载本地视频文件
    private func loadLocalMovieFile(path:String) -> MPMoviePlayerController?{
        
        if NSFileManager.defaultManager().isReadableFileAtPath(path)
        {
            let url = NSURL.fileURLWithPath(path)
            if let player = MPMoviePlayerController(contentURL: url )
            {
                player.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                player.view.sizeToFit()
                player.scalingMode = MPMovieScalingMode.AspectFit
                player.controlStyle = MPMovieControlStyle.Fullscreen
                player.movieSourceType = MPMovieSourceType.File
                player.repeatMode = MPMovieRepeatMode.None//不重复播放
                
                return player
            }
        }
        
        return nil
    }
    
    private func addListener(){
        
        if let player = moviePlayer
        {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayerDidChangeState:", name: MPMoviePlayerPlaybackStateDidChangeNotification, object: player)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "didEnterFullscreen:", name: MPMoviePlayerDidEnterFullscreenNotification, object: player)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "willEnterFullscreen:", name:MPMoviePlayerWillEnterFullscreenNotification, object: player)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "playbackDidFinish:", name: MPMoviePlayerPlaybackDidFinishNotification, object: player)
        }
    }
    
    //开始播放
    private func play(){
        if let player = self.moviePlayer
        {
            player.play()
            
            addListener()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        println("初始化播放器")
        
        //本地视频文件
        if let player = loadLocalMovieFile(model.currMovieFilePath)
        {
            self.moviePlayer = player
            self.view.addSubview(player.view)
            play()
            
            //加载字幕
            if let subtitlesPath = model.currSubtitlesFilePath
            {
                if openSRTFileAtPath(subtitlesPath)
                {
                    displaySubtitles()
                }
            }
        }
    }
    

    /**
     * 加载srt格式字幕文件
     * @param path 字幕文件路径
    */
    private func openSRTFileAtPath(path:String)->Bool
    {
        var contents : String = NSString(contentsOfFile:path, encoding: NSUTF8StringEncoding, error: nil) as! String
        if model.parseRSTSubtitleString(contents)
        {
            return true
        }
        
        return false
    }
    

    var subtitlesTimer:NSTimer?
    
    /**
     * 启用定时器
    */
    func startTimer(){
        
        stopTimer()
        
        subtitlesTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "searchAndShowSubtitle", userInfo: nil, repeats:true);
        subtitlesTimer?.fire()
    }
    
    /**
    * 停止定时器
    */
    func stopTimer(){
        subtitlesTimer?.invalidate()
        subtitlesTimer = nil
    }
    

    
    /**
    * 修改字幕的位置
    */
    func updateLabelConstraints(){
        
        if let label = subtitleLabel {
            label.frame = CGRectMake(0, self.view.frame.size.height - textSize.height - SUBTITLES_BOTTOM_OFFSET, self.view.frame.size.width, textSize.height)
        }
    }
    
    private var textSize:CGSize{
        get{
            if let text = subtitlesText
            {
                return CommonUtils.getSizeOfText(text, font: textFont)
            }
            else{
                return CGSizeZero
            }
        }
    }
    
    func searchAndShowSubtitle(){
        if let player = moviePlayer{
            subtitlesText = model.searchAndShowSubtitle(player.currentPlaybackTime)
        }
    }
    
    private func isIpadDevice()->Bool
    {
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad{
            return true
        }
        
        return false
    }
    
    /**
    * 字母与屏幕顶部的偏移量
    */
    private var SUBTITLES_BOTTOM_OFFSET:CGFloat
    {
        get{
            if isIpadDevice()
            {
                return 100
            }
            else{
                return 50
            }
        }
    }
    
    
    /**
     * 字母字体大小
    */
    private var fontSize:CGFloat
    {
        get
        {
            if isIpadDevice()
            {
                return 30
            }
            else{
                return 20
            }
        }
    }
    
    private var textFont:UIFont{
        get
        {
            return UIFont(name: "Helvetica Neue", size: fontSize)!
        }
    }
    
    
    func moviePlayerDidChangeState(note: NSNotification)
    {
        if let playbackState = moviePlayer?.playbackState
        {
            switch playbackState{
            case MPMoviePlaybackState.Playing:
                println("--------->1")
            case MPMoviePlaybackState.Paused:
                println("停止播放")
            case MPMoviePlaybackState.Interrupted:
                println("--------->3")
            case MPMoviePlaybackState.SeekingBackward:
                println("--------->4")
            case MPMoviePlaybackState.SeekingForward:
                println("--------->5")
            case MPMoviePlaybackState.Stopped:
                println("--------->6")
            default : break
            }
        }
        
        
    }
    
    //显示字幕
    private func displaySubtitles()
    {
        if subtitleLabel == nil
        {
            subtitleLabel = UILabel(frame:CGRectMake((self.view.frame.size.width - textSize.width)*0.5,
                self.view.frame.size.height - textSize.height - SUBTITLES_BOTTOM_OFFSET,
                textSize.width,
                textSize.height))
            subtitleLabel!.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
            subtitleLabel!.textAlignment = NSTextAlignment.Center
            subtitleLabel!.textColor = UIColor.whiteColor()
            subtitleLabel!.numberOfLines = 0;
            subtitleLabel!.font = textFont
            subtitleLabel!.text = ""
            subtitleLabel!.layer.shadowColor = UIColor.blackColor().CGColor
            subtitleLabel!.layer.shadowOffset = CGSizeMake(6.0, 6.0)
            subtitleLabel!.layer.shadowOpacity = 0.9
            subtitleLabel!.layer.shadowRadius = 4.0
            subtitleLabel!.layer.shouldRasterize = true
            subtitleLabel!.layer.rasterizationScale = UIScreen.mainScreen().scale
            self.view?.addSubview(subtitleLabel!)
        }
        
        startTimer()
    }

    /**
    * 将要进入全屏状态
    */
    func willEnterFullscreen(note: NSNotification){
        
        println("willEnterFullscreen")
        
        subtitleLabel?.hidden = true
        
        var window = UIApplication.sharedApplication().keyWindow
        if window == nil {
            window = UIApplication.sharedApplication().windows[0] as? UIWindow
        }
        
        if let label = subtitleLabel {
            window?.addSubview(label)
        }
    }

    /**
     * 进入全屏状态
    */
    func didEnterFullscreen(note: NSNotification){
        println("didEnterFullscreen")

        subtitleLabel?.hidden = false
    }
    
    func playbackDidFinish(note: NSNotification){
        println("停止播放")
        
        stopMoviePlayer()
    }
    
    /**
     *
    */
    private func stopMoviePlayer()
    {
        stopTimer()
        
        self.dismissMoviePlayerViewControllerAnimated()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     *
    */
    func removeListener()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    deinit{
        println("释放视频资源!")
        
        removeListener()
    }
}
