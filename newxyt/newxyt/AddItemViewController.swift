//
//  AddItemViewController.swift
//  newxyt
//
//  Created by 谭钧豪 on 16/3/28.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit
import Photos
import Qiniu


class AddItemLine: UIView {
    override func drawRect(rect:CGRect){
        let context =  UIGraphicsGetCurrentContext();//获取画笔上下文
        CGContextSetAllowsAntialiasing(context, true) //抗锯齿设置
        //画直线
        CGContextSetLineWidth(context, 1) //设置画笔宽度
        CGContextSetRGBStrokeColor(context, 0.87, 0.87, 0.87, 1)
        CGContextMoveToPoint(context,0, 40);
        CGContextAddLineToPoint(context,rect.width, 40);
        CGContextMoveToPoint(context,0, 80);
        CGContextAddLineToPoint(context,rect.width, 80);
        CGContextMoveToPoint(context,0, 290);
        CGContextAddLineToPoint(context,rect.width, 290);
        CGContextMoveToPoint(context,0, 400);
        CGContextAddLineToPoint(context,rect.width, 400);
        CGContextStrokePath(context)
        
    }
}
class AddItemViewController: UIViewController, UITextFieldDelegate {

    
    var nametf:UITextField!
    var contentView:UITextField!
    var pricetf:UITextField!
    var mainscreen:CGRect!
    var assetsFetchResults:PHFetchResult!
    var selectImages:[Int] = [Int]()
    var tipLabel:UILabel!
    var selectView:UIView!
    var selectPicThumb:UIScrollView!
    let userid = NSUserDefaults.standardUserDefaults().valueForKey("username")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainscreen = UIScreen.mainScreen().bounds
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationController?.navigationBar.translucent = false
        self.tabBarController?.tabBar.translucent = false
        self.view = AddItemLine(frame: mainscreen)
        self.view.backgroundColor = UIColor.whiteColor()
        let nametip = UILabel(frame: CGRectMake(5,5,90,30))
        nametip.text = "宝贝名称:"
        self.view.addSubview(nametip)
        nametf = UITextField(frame: CGRectMake(90,5,270,30))
        nametf.layer.borderColor = UIColor.lightGrayColor().CGColor
        nametf.layer.borderWidth = 1
        self.view.addSubview(nametf)
        let pricetip = UILabel(frame: CGRectMake(5,45,90,30))
        pricetip.text = "价格:"
        pricetip.textAlignment = NSTextAlignment.Center
        self.view.addSubview(pricetip)
        pricetf = UITextField(frame: CGRectMake(90,45,270,30))
        pricetf.delegate = self
        pricetf.keyboardType = UIKeyboardType.NumberPad
        pricetf.layer.borderColor = UIColor.lightGrayColor().CGColor
        pricetf.layer.borderWidth = 1
        self.view.addSubview(pricetf)
        contentView = UITextField(frame: CGRectMake(5, 85, self.view.frame.width-10, 200))
        contentView.textAlignment = NSTextAlignment.Natural
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.view.addSubview(contentView)
        let addpic = UIImageView(image: UIImage(named: "icon_addpic"))
        addpic.userInteractionEnabled = true
        addpic.frame = CGRectMake(5, 295, 100, 100)
        let addpicTap = UITapGestureRecognizer(target: self, action: #selector(self.addPic(_:)))
        addpic.addGestureRecognizer(addpicTap)
        self.view.addSubview(addpic)
        selectPicThumb = UIScrollView(frame: CGRectMake(110,295,self.view.frame.width-120,100))
        self.view.addSubview(selectPicThumb)
        let submitBtn = UIButton(type: UIButtonType.System)
        submitBtn.frame = CGRectMake(mainscreen.width/2 - 60, 405, 120, 30)
        submitBtn.backgroundColor = UIColor(red:0.05, green:0.60, blue:0.99, alpha:1.00)
        submitBtn.layer.cornerRadius = 8
        submitBtn.setTitle("提交", forState: UIControlState.Normal)
        submitBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        submitBtn.addTarget(self, action: #selector(self.submit), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(submitBtn)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var tmpSet = NSCharacterSet(charactersInString: "1234567890.")
        let str = textField.text!
        if str.characters.count >= 9 && string != "" && string != "."{
            let alert = UIAlertController(title: "提示", message: "卖的价格太高了，不能卖这么多钱", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        if textField.text!.containsString("."){
            let strArry = str.componentsSeparatedByString(".")
            if strArry[0].characters.count >= 9 && string != ""{
                return false
            }
            if strArry[1].characters.count >= 2 && string != ""{
                return false
            }
            tmpSet = NSCharacterSet(charactersInString: "1234567890")
        }
        
        return validateNumber(string,characterSet: tmpSet)
    }
    
    
    func validateNumber(number:String,characterSet:NSCharacterSet) -> Bool{
        let numberstr = NSString(string: number)
        var res = true
        var i:Int = 0
        while (i < number.characters.count) {
            let string = numberstr.substringWithRange(NSMakeRange(i, 1))
            if let _ = string.rangeOfCharacterFromSet(characterSet){
            }else{
                res = false;
                break;
            }
            i+=1;
        }
        return res;
    }
    
    func submit(){
        let selectPics = NSMutableArray(capacity: selectImages.count)
        let phImageRequestOption = PHImageRequestOptions()
        phImageRequestOption.synchronous = true
        for i in 0..<selectImages.count{
            var statu = false
            for _ in 0..<4{
                PHImageManager().requestImageForAsset(assetsFetchResults[selectImages[i]] as! PHAsset, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.AspectFill, options: phImageRequestOption, resultHandler: { (image, info) in
                    if let _ = info!["PHImageErrorKey"]{
                        statu = false
                    }else{
                        selectPics[i] = image!
                        statu = true
                    }
                    
                })
                if statu{statu=false;break}
            }
        }
        request(selectPics)
//        qiniuRequest(selectPics)
        
        
    }
    
    func qiniuRequest(selectPics:NSMutableArray){
        var cancelSignal:Bool!
        cancelSignal = false
        let token = "U-xnzz4CMEqM8lSW1HisWIDflYDvIHlyWTCIigAm:1Ci-tEc5q6zyN80Jlc9x2kY9R6Q=:eyJzY29wZSI6ImNvbS1qbHN0dWRpbyIsImRlYWRsaW5lIjozMjM3ODMxMTEyfQ=="
        let upManager = QNUploadManager()
        var data = NSData()
        for pic in selectPics{
            data = UIImageJPEGRepresentation((pic as! UIImage),1)!
            upManager.putData(data, key: nil, token: token, complete: { (info, key, resp) in
                print(info)
                print(resp)
                }, option: QNUploadOption(mime: nil, progressHandler: { (key, percent) in
                    
                    }, params: nil, checkCrc: false, cancellationSignal: { () -> Bool in
                        return cancelSignal
                })
            )
        }
    }
    
    func request(selectPics:NSMutableArray){
        let session = NSURLSession.sharedSession()
        let semaphore = dispatch_semaphore_create(0)
        let url = NSURL(string: Config.ip+"uploadgoods")!
        let request = NSMutableURLRequest(URL: url)
        request.timeoutInterval = 3
        request.HTTPMethod = "POST"
        request.addValue("multipart/form-data; boundary=AaB03x", forHTTPHeaderField: "Content-Type")
        
        let data = NSMutableData()
        data.appendData(NSString(string: "\r\n--AaB03x\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        data.appendData(NSString(string: "content-disposition: form-data; name=\"data\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        data.appendData(NSString(string: "{\"userid\":\"\(userid!)\",\"price\":\"\(pricetf.text!)\",\"description\":\"\(nametf.text!)\":\"\(contentView.text!)\"}").dataUsingEncoding(NSUTF8StringEncoding)!)
        
        for i in 0..<selectPics.count{
            data.appendData(NSString(string: "\r\n--AaB03x\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            data.appendData(NSString(string: "Content-Disposition: form-data; name=\"jpg\"; filename=\"file\(i).jpg\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            data.appendData(UIImageJPEGRepresentation(selectPics[i] as! UIImage, 0.9)!)
        }
        
        data.appendData(NSString(string: "\r\n--AaB03x--\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        
        request.HTTPBody = data
        
        let dataTask = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, resperror) -> Void in
            if resperror != nil{
                print("获取出错")
                print(resperror)
            }else{
                do{
                    let statustr = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSNumber
                    print(statustr)
                    
                }catch{
                    print(error)
                
                }
            }
            dispatch_semaphore_signal(semaphore)
            
        }) as NSURLSessionTask
        dataTask.resume()//启动线程
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)//等待线程结束
    }
    
    func addPic(sender:UITapGestureRecognizer) {
        sender.view?.userInteractionEnabled = false
        selectView = UIView(frame: CGRectMake(0,mainscreen.size.height,mainscreen.size.width,mainscreen.size.height))
        let selectPicView = UIScrollView(frame: CGRectMake(0,55,mainscreen.size.width,mainscreen.size.height-155))
        selectView.backgroundColor = UIColor.whiteColor()
        tipLabel = UILabel(frame: CGRectMake(mainscreen.size.width/2-50,20,100,30))
        tipLabel.text = "已选择\(self.selectImages.count)张"
        tipLabel.textAlignment = NSTextAlignment.Center
        selectView.addSubview(tipLabel)
        
        
        let cancelbtn = UIButton(frame: CGRectMake(5,mainscreen.size.height-90,60,30))
        cancelbtn.backgroundColor = UIColor.redColor()
        cancelbtn.layer.cornerRadius = 8
        cancelbtn.setTitle("取消", forState: UIControlState.Normal)
        cancelbtn.addTarget(self, action: #selector(self.cancelSelect(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let previewbtn = UIButton(frame: CGRectMake(mainscreen.size.width-140,mainscreen.size.height-90,60,30))
        previewbtn.setTitle("预览", forState: UIControlState.Normal)
        previewbtn.titleLabel?.textColor = UIColor(red:0.05, green:0.60, blue:0.99, alpha:1.00)
        let confirmbtn = UIButton(frame: CGRectMake(mainscreen.size.width-70,mainscreen.size.height-90,60,30))
        confirmbtn.backgroundColor = UIColor(red:0.25, green:0.77, blue:0.94, alpha:1.00)
        confirmbtn.layer.cornerRadius = 8
        confirmbtn.setTitle("确定", forState: UIControlState.Normal)
        confirmbtn.addTarget(self, action: #selector(self.confirmSelect(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        selectView.addSubview(cancelbtn)
        selectView.addSubview(previewbtn)
        selectView.addSubview(confirmbtn)
        
        selectView.addSubview(selectPicView)
        self.view.addSubview(selectView)
        
        UIView.animateWithDuration(0.3, animations: {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.selectView.frame.origin.y = 0
            },completion: {
                (_) -> Void in
                sender.view?.userInteractionEnabled = true
        })
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        assetsFetchResults = PHAsset.fetchAssetsWithOptions(option)
        selectPicView.contentSize = CGSizeMake(mainscreen.size.width, 125+CGFloat(assetsFetchResults.count/4)*91)
        //内存消耗太大，要改成重用，如果以后有时间会改。
        for i in 0..<assetsFetchResults.count {
            let imageView = UIImageView(frame: CGRectMake(11+CGFloat(i%4)*91, 11+CGFloat(i/4)*91, 80, 80))
            imageView.userInteractionEnabled = true
            imageView.tag = 100+i
            
            let imageTap = UITapGestureRecognizer(target: self, action: #selector(self.selectPic(_:)))
            imageView.addGestureRecognizer(imageTap)
            selectPicView.addSubview(imageView)
            
            let whiteView = UIView(frame: CGRectMake(0,0,imageView.frame.size.width,imageView.frame.size.height))
            whiteView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            whiteView.tag = 2
            let selectedView = UIImageView(frame: CGRectMake(imageView.frame.size.width-25, 5, 20, 20))
            selectedView.image = UIImage(named: "selected")
            selectedView.tag = 1
            if self.selectImages.contains(i){
                imageView.addSubview(whiteView)
                imageView.addSubview(selectedView)
            }
            let phImageRequestOption = PHImageRequestOptions()
            phImageRequestOption.resizeMode = PHImageRequestOptionsResizeMode.Exact
            var statu = false
            for _ in 0..<4{
                PHImageManager().requestImageForAsset(assetsFetchResults[i] as! PHAsset, targetSize: CGSizeMake(140, 140), contentMode: PHImageContentMode.AspectFill, options: phImageRequestOption, resultHandler: { (image, info) in
                    if let _ = info!["PHImageErrorKey"]{
                        statu = false
                    }else{
                        imageView.image = image
                        statu = true
                    }
                })
                if statu{break}
            }
        }
        
    }
    
    func confirmSelect(sender:UIButton){
        let _ = self.selectPicThumb.subviews.map({ $0.removeFromSuperview() })
        self.selectPicThumb.contentSize = CGSizeMake(CGFloat(selectImages.count)*110, 100)
        for i in 0..<selectImages.count{
            let thumbnail = UIImageView(frame: CGRectMake(110*CGFloat(i), 0, 100, 100))
            thumbnail.tag = i
            thumbnail.userInteractionEnabled = true
            let removeBtn = UIButton(type: UIButtonType.System)
            removeBtn.frame = CGRectMake(thumbnail.frame.size.width-24, 5, 24, 24)
            removeBtn.layer.cornerRadius = 12
            removeBtn.backgroundColor = UIColor.redColor()
            removeBtn.setTitle("一", forState: UIControlState.Normal)
            removeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            removeBtn.addTarget(self, action: #selector(self.removeThumb(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            thumbnail.addSubview(removeBtn)
            
            self.selectPicThumb.addSubview(thumbnail)
            for _ in 0..<4{
                var statu = false
                PHImageManager().requestImageForAsset(assetsFetchResults[selectImages[i]] as! PHAsset, targetSize: CGSizeMake(160, 160), contentMode: PHImageContentMode.Default, options: nil, resultHandler: { (image, info) in
                    if let _ = info!["PHImageErrorKey"]{
                        statu = false
                    }else{
                        thumbnail.image = image
                        statu = true
                    }
                })
                if statu{break}
            }
            
        }
        cancelSelect(sender)
        
    }
    
    func removeThumb(sender:UIButton){
        let index = sender.superview!.tag
        let views = sender.superview!.superview!.subviews
        sender.superview?.removeFromSuperview()
        selectImages.removeAtIndex(index)
        for view in views{
            if view.tag > index{
                view.tag -= 1
                UIView.animateWithDuration(0.3, animations: {
                    view.frame.origin.x -= 110
                    })
            }
        }
        
    }
    
    func cancelSelect(sender:UIButton){
        UIView.animateWithDuration(0.5, animations: {
            self.navigationController?.navigationBarHidden = false
            sender.superview?.frame.origin.y = self.view.frame.height
            }) { (finish) in
                let subViews = self.selectView.subviews
                for subView in subViews{
                    subView.removeFromSuperview()
                }
                self.selectView = nil
                
        }
    }
    
    func selectPic(sender:UITapGestureRecognizer){
        if selectImages.count < 6 {
            let imageView = sender.view as! UIImageView
            let index = imageView.tag - 100
            let whiteView = UIView(frame: CGRectMake(0,0,imageView.frame.size.width,imageView.frame.size.height))
            whiteView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            whiteView.tag = 2
            let selectedView = UIImageView(frame: CGRectMake(imageView.frame.size.width-25, 15, 20, 20))
            selectedView.image = UIImage(named: "selected")
            selectedView.tag = 1
            if self.selectImages.contains(index){
                imageView.viewWithTag(1)?.removeFromSuperview()
                imageView.viewWithTag(2)?.removeFromSuperview()
                self.selectImages.removeAtIndex(self.selectImages.indexOf(index)!)
                tipLabel.text = "已选择\(selectImages.count)张"
            }else{
                imageView.addSubview(whiteView)
                imageView.addSubview(selectedView)
                self.selectImages.append(index)
                tipLabel.text = "已选择\(selectImages.count)张"
            }
        }else{
            let imageView = sender.view as! UIImageView
            let index = imageView.tag - 100
            if self.selectImages.contains(index){
                imageView.viewWithTag(1)?.removeFromSuperview()
                imageView.viewWithTag(2)?.removeFromSuperview()
                self.selectImages.removeAtIndex(self.selectImages.indexOf(index)!)
                tipLabel.text = "已选择\(selectImages.count)张"
            }else{
                let alert = UIAlertController(title: "提示", message: "您已经选择了6张照片，不能再选了", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "好", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        nametf.resignFirstResponder()
        contentView.resignFirstResponder()
        pricetf.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
