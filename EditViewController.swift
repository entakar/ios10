//
//  EditViewController.swift
//  痛っタイマー
//
//  Created by EndoTakashi on 2016/05/04.
//  Copyright © 2016年 tak. All rights reserved.
//

import UIKit

class EditViewController: UIViewController,UITableViewDelegate,
UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    var ImageView:UIImage = UIImage()
    var ImageFlag = true
    
    @IBOutlet weak var sampleLabel: UILabel!
    
    @IBOutlet weak var RSlider: UISlider!
    @IBOutlet weak var GSlider: UISlider!
    @IBOutlet weak var BSlider: UISlider!
    
    var colorR:Float = 0.0
    var colorG :Float = 0.0
    var colorB:Float = 0.0
    var colorItem = [Float]()
    override func viewDidLoad() {
        super.viewDidLoad()
        RSlider.value = NSUserDefaults.standardUserDefaults().floatForKey("colorR")
        GSlider.value = NSUserDefaults.standardUserDefaults().floatForKey("colorG")
        BSlider.value = NSUserDefaults.standardUserDefaults().floatForKey("colorB")
        
        sampleLabel.textColor = UIColor(colorLiteralRed: colorR, green: colorG, blue: colorB , alpha: 1)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func imageClear(){
        ImageFlag = false
        //保存先dir /documents
        let fileManager = NSFileManager.defaultManager()
        let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let fileName = "/mainImage.png"
        let path = dir + fileName
        // 保存
        if  fileManager.fileExistsAtPath(path) {
            do{
                try fileManager.removeItemAtPath(path)
            }
            catch{
                print ("写真削除")
            }
        }// 保存エラー
        else {
            print("error writing file: \(path)")
        }
    }
    
    //slider
    @IBAction func colorSliderChange(sender: UISlider){
        colorR = RSlider.value
        colorG = GSlider.value
        colorB = BSlider.value
        sampleLabel.textColor = UIColor(colorLiteralRed: colorR, green: colorG, blue: colorB , alpha: 1)
        NSUserDefaults.standardUserDefaults().setFloat(RSlider.value, forKey: "colorR")
        NSUserDefaults.standardUserDefaults().setFloat(GSlider.value, forKey: "colorG")
        NSUserDefaults.standardUserDefaults().setFloat(BSlider.value, forKey: "colorB")
    }
    // func totchPic(sourceType: UIImagePickerControllerSourceType){
    // カメラロールから写真を選ぶためのメソッド
    @IBAction  func accessCameraroll(button: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    //   }
    
    //====================
    //UIImagePickerControllerDelegate
    //====================
    //イメージピッカーのイメージ取得時に呼ばれる
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        //イメージの指定
        let photo: UIImage = info[UIImagePickerControllerOriginalImage]
            as! UIImage
        ImageView = photo
        
        if let photodata = UIImagePNGRepresentation(photo) {
            
            //保存先dir /documents
            let fileManager = NSFileManager.defaultManager()
            let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            let fileName = "/mainImage.png"
            let path = dir + fileName
            
            // 保存
            if (photodata.writeToFile(path, atomically: true)) {
                print ("写真保存")
                photodata.writeToFile(path, atomically: true)
            }
            else {
                print ("保存エラー")
                print("error writing file: \(path)")
            }
            
        }
        //ビューコントローラのビューを閉じる
        picker.presentingViewController?
            .dismissViewControllerAnimated(true, completion: nil)
    }
    
    //イメージピッカーのキャンセル時に呼ばれる(3)
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //ビューコントローラのビューを閉じる
        picker.presentingViewController?
            .dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showAlert(title: String?, text: String?){
        let alert = UIAlertController(title: title, message: text, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK",style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //View間の値受け渡し
    override func prepareForSegue(segue:UIStoryboardSegue , sender: AnyObject!){
        var SegueView = segue.destinationViewController as! ViewController
        if ImageFlag {
            //SegueView.mainImage = ImageView
        }else{
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
