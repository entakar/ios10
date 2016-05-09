//
//  ViewController.swift
//  ios10
//
//  Created by EndoTakashi on 2016/04/25.
//  Copyright © 2016年 tak. All rights reserved.
//

import UIKit
import AVFoundation



class ViewController: UIViewController,UITableViewDelegate,
UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    //オブジェクト
    @IBOutlet weak var START: UIButton!
    @IBOutlet weak var STOP: UIButton!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var ImageView: UIImageView!

    //初期値
    var StartTime: NSTimeInterval? = nil
    var timer = NSTimer()
    let _Start  = 0
    let _Stop   = 1
    let _Pic    = 2
    var Count:Int   = 0
    var hour:Int    = 0
    var time:Int    = 0
    var sec:Int     = 0
    //image
    var mainImage:UIImage = UIImage()
    var RR:Float = 0.0
    var GG:Float = 0.0
    var BB:Float = 0.0

    //
    var items:String = ""
    var _player = [AVAudioPlayer]() //プレイヤー
    let BTN_BGM_PLAY = 0 //BGM再生/停止
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        STOP.enabled = false
        
        //保存先dir /documents
        let fileManager = NSFileManager.defaultManager()
        let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        //保存Image使用
        let fileName = "/mainImage.png"
        let path = dir + fileName
        
        if fileManager.fileExistsAtPath(path){
            ImageView.image = UIImage(contentsOfFile: path)
            //print ("写真保存")
        }else{
            ImageView.image = mainImage
            //print ("写真なし")
        }

        RR = NSUserDefaults.standardUserDefaults().floatForKey("colorR")
        GG = NSUserDefaults.standardUserDefaults().floatForKey("colorG")
        BB = NSUserDefaults.standardUserDefaults().floatForKey("colorB")
        DateLabel.textColor = UIColor(colorLiteralRed: RR, green: GG, blue: BB, alpha: 1)
        START.setTitleColor(
            UIColor(colorLiteralRed: RR, green: GG, blue: BB, alpha: 1)
                , forState: .Normal)
        STOP.setTitleColor(
            UIColor(colorLiteralRed: RR, green: GG, blue: BB, alpha: 1)
                , forState: .Normal)
        
        //プレイヤーの作成
        _player.append(makeAudioPlayer("でんでんぱっしょん.mp3")!)

    }
    @IBAction func TotchButton(sender: UIButton){
        if sender.tag == _Start{
            totchStart()
        }else if sender.tag == _Stop{
            totchStop()
        }
    }
    
    func totchStart(){
        DatePicker.hidden = true
        Count = Int(DatePicker.countDownDuration)
        //秒数を切り捨て
        hour =  ((Count / 60) / 60)
        time = (Count - (hour * 60 * 60)) / 60
        Count = Count - (Count - ((hour * 60 * 60) + (time * 60)))
        //timerを生成する.
        timer = NSTimer.scheduledTimerWithTimeInterval(
            1,
            target: self,
            selector: Selector("step"),
            userInfo: nil,
            repeats: true)
        START.enabled = false
        STOP.enabled = true
    }
    func step(){
        hour =  ((Count / 60) / 60)
        time = (Count - (hour * 60 * 60)) / 60
        sec  = ((Count - ((hour * 60 * 60) + (time * 60)) ) )
        self.DateLabel.text = String(format: "%02d:%02d:%02d",hour,time,sec)
        Count--
        if( Count < 0){
            timer.invalidate()
            _player[0].currentTime = 9999
            _player[0].play()
            alertOkCancel("完了", messe:"時間になりました")
        }
        
    }
    //オーディオプレーヤーの生成
    func makeAudioPlayer(res:String) -> AVAudioPlayer? {
        //リソースURLの生成(1)
        let path = NSBundle.mainBundle().pathForResource(res, ofType: "")
        let url = NSURL.fileURLWithPath(path!)
        
        do {
            //オーディオプレーヤーの生成(2)
            return try AVAudioPlayer(contentsOfURL: url)
        } catch _ {
            return nil
        }
    }
    //タイマー停止
    func timerStop(){
        timer.invalidate()
        DatePicker.hidden = false
        DateLabel.text = nil
        START.enabled = true
        STOP.enabled = false
        _player[0].stop()
    }
    func totchStop(){
        alertOkCancel("停止", messe:"停止します")
    }
    func alertOkCancel(alertTitle:String, messe: String ){
        //アラート作成
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .Alert
        )
        alert.title = alertTitle
        alert.message = messe
        // OKボタン
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertActionStyle.Default,
                handler: {(action) -> Void in
                    self.timerStop()
                }
            )
        )
        // キャンセル（追加順にかかわらず最後に表示される）
        alert.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: UIAlertActionStyle.Cancel,
                handler: nil)
        )
        
        // アラートを表示する
        self.presentViewController(
            alert,
            animated: true,
            completion: nil
        )

    }
    
    //View間の値受け渡し
    override func prepareForSegue(segue:UIStoryboardSegue , sender: AnyObject!){
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
}

