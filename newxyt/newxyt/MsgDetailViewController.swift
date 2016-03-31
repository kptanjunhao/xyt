//
//  MsgDetailViewController.swift
//  newxyt
//
//  Created by 谭钧豪 on 16/2/28.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

class MsgDetailLine: UIView {
    override func drawRect(rect:CGRect){
        let context =  UIGraphicsGetCurrentContext();//获取画笔上下文
        CGContextSetAllowsAntialiasing(context, true) //抗锯齿设置
        //画直线
        CGContextSetLineWidth(context, 1) //设置画笔宽度
        CGContextSetRGBStrokeColor(context, 0.47, 0.47, 0.47, 1)
        CGContextMoveToPoint(context,10, 70);
        CGContextAddLineToPoint(context,rect.width-10, 70);
        CGContextStrokePath(context)
    }
}

class MsgDetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var msgTitle: UILabel!
    @IBOutlet weak var fromwho: UILabel!
    @IBOutlet weak var fromtime: UILabel!
    var content: UITextView!
    var isrec = true
    var flag = ""
    var noticeid = ""
    var noticegroup = ""
    var contenttext:String?
    let userid = String(NSUserDefaults.standardUserDefaults().valueForKey("username")!)
    override func viewDidLoad() {
        super.viewDidLoad()
        let contentframe = CGRectMake(10, fromwho.frame.origin.y+8, self.view.frame.width-20, 390)
        content = UITextView(frame: contentframe)
        content.font = UIFont.systemFontOfSize(18)
        content.inputView = UIView(frame: CGRectZero)
        content.layer.borderColor = UIColor.grayColor().CGColor
        content.layer.borderWidth = 1
        content.layer.cornerRadius = 5
        content.editable = false
        
        getmsgDetail()
        var confirmframe:CGRect!
        var deleteframe:CGRect!
        if flag == "1" || !isrec{
            confirmframe = CGRectZero
            deleteframe = CGRectMake(20,self.view.frame.height - 101 - (self.tabBarController?.tabBar.frame.height ?? 0),self.view.frame.width - 40,30)
        }else{
            confirmframe = CGRectMake(10,self.view.frame.height - 101 - (self.tabBarController?.tabBar.frame.height ?? 0),self.view.frame.width/2 - 20,30)
            deleteframe = CGRectMake(self.view.frame.width/2 + 10,self.view.frame.height - 101 - (self.tabBarController?.tabBar.frame.height ?? 0),self.view.frame.width/2 - 20,30)
        }
        
        self.view.addSubview(content)
        let confirm = UIButton(frame: confirmframe)
        confirm.setTitle("确定", forState: .Normal)
        confirm.layer.cornerRadius = 10
        confirm.tag = 1
        confirm.addTarget(self, action: #selector(MsgDetailViewController.confirmmsg(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        confirm.backgroundColor = UIColor(red:0.37, green:0.64, blue:0.98, alpha:1)
        
        
        let delete = UIButton(frame: deleteframe)
        delete.setTitle("删除", forState: .Normal)
        delete.layer.cornerRadius = 10
        delete.tag = 2
        delete.addTarget(self, action: #selector(MsgDetailViewController.confirmmsg(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        delete.backgroundColor = UIColor.redColor()
        
        
        self.view.addSubview(confirm)
        self.view.addSubview(delete)
        

        // Do any additional setup after loading the view.
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func confirmmsg(sender:UIButton){
        var action = ""
        var url = ""
        var message = ""
        if sender.tag == 1{
            message = "确认通知"
            action = "noticeconfirm?data="
            url = "{\"noticeid\":\"\(noticeid)\",\"username\":\"\(userid)\"}"
        }else if sender.tag == 2{
            message = "删除"
            action = "deletenotice?data="
            url = "{\"noticeid\":\"\(noticeid)\",\"fromorto\":\"2\"}"
        }
       
        
        url = Config.ip + action + url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet())!
        let request = NSURLRequest(URL:NSURL(string:url)!,cachePolicy:NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData,timeoutInterval:5.0)
        let session = NSURLSession.sharedSession()
        let semaphore = dispatch_semaphore_create(0)
        let dataTask = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            if error != nil{
                let warning = UIAlertController(title: "提示", message: "与服务器连接发生错误", preferredStyle: .Alert)
                let ok = UIAlertAction(title: "好", style: .Default, handler: {
                    (OK) -> Void in
                    self.navigationController?.popViewControllerAnimated(true)
                })
                warning.addAction(ok)
                self.presentViewController(warning, animated: true, completion: nil)
            }else{
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? Int
                    if json == 0{
                        let warning = UIAlertController(title: "提示", message: message+"成功", preferredStyle: .Alert)
                        let ok = UIAlertAction(title: "好", style: .Default, handler: {
                            (OK) -> Void in
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                        warning.addAction(ok)
                        self.presentViewController(warning, animated: true, completion: nil)
                    }else{
                        let warning = UIAlertController(title: "提示", message: message+"失败，请联系管理员", preferredStyle: .Alert)
                        let ok = UIAlertAction(title: "好", style: .Default, handler: {
                            (OK) -> Void in
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                        warning.addAction(ok)
                        self.presentViewController(warning, animated: true, completion: nil)
                    }
                    
                }catch{print("解析出错")}
            }
            dispatch_semaphore_signal(semaphore)
            
        }) as NSURLSessionTask
        
        dataTask.resume()//启动线程
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)//等待线程结束
        self.content.text = self.contenttext
        
    }
    
    
    func getmsgDetail(){
        
        let action = isrec ? "recmsg?data=" : "sendmsg?data="
        var url = isrec ? "{\"noticeid\":\"\(noticeid)\"}" : "{\"noticeid\":\"\(noticeid)\",\"noticegroup\":\"\(noticegroup)\"}"
        url = Config.ip + action + url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet())!
        let request = NSURLRequest(URL:NSURL(string:url)!,cachePolicy:NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData,timeoutInterval:10.0)
        let session = NSURLSession.sharedSession()
        let semaphore = dispatch_semaphore_create(0)
        let dataTask = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            if error != nil{
                let warning = UIAlertController(title: "提示", message: "获取通知详情出错", preferredStyle: .Alert)
                let ok = UIAlertAction(title: "好", style: .Default, handler: {
                    (OK) -> Void in
                    self.navigationController?.popViewControllerAnimated(true)
                })
                warning.addAction(ok)
                self.presentViewController(warning, animated: true, completion: nil)
            }else{
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    self.msgTitle.text = json.objectForKey("noticetitle") as? String
                    self.fromwho.text = json.objectForKey("realname") as? String
                    self.fromtime.text = (json.objectForKey("datetime") as? NSString)?.substringToIndex(19)
                    self.contenttext = json.objectForKey("noticetext") as? String
                    
                }catch{print("解析出错")}
            }
            dispatch_semaphore_signal(semaphore)
            
        }) as NSURLSessionTask
        
        dataTask.resume()//启动线程
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)//等待线程结束
        self.content.text = self.contenttext
    }
    


}
