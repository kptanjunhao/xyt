//
//  MoreCollectionViewController.swift
//  newxyt
//
//  Created by 谭钧豪 on 16/2/2.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MoreCollectionViewController: UICollectionViewController, UIAlertViewDelegate, UITextFieldDelegate {
    //配置不同图标的segue
    let item = [
        ["name":"查询课表","pic":"course","action":"course"],
        ["name":"查询CET","pic":"glasses","action":"cet"],
        ["name":"查询绩点","pic":"pen","action":"score"],
        ["name":"查看天气","pic":"umberalla","action":"weather"]
    ]
    let ip = NSUserDefaults.standardUserDefaults().valueForKey("ip") as! String
    var json:AnyObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置背景
        self.collectionView?.scrollEnabled = false
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return item.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        let img = UIImageView(image: UIImage(named: item[indexPath.item]["pic"]!))
        img.userInteractionEnabled = true
        img.tag = indexPath.row
        img.frame = cell.bounds
        img.layer.shadowOpacity = 0.8
        img.layer.shadowColor = UIColor.blackColor().CGColor
        img.layer.shadowOffset = CGSize(width: 1, height: 1)
        img.layer.shadowRadius = 2
        
        let label = UILabel(frame: CGRectMake(0,115,cell.bounds.size.width,20))
        label.textAlignment = NSTextAlignment.Center
        label.text = item[indexPath.item]["name"]
        let tap = UITapGestureRecognizer(target: self, action: #selector(MoreCollectionViewController.jumptofuncview(_:)))
        img.addGestureRecognizer(tap)
        cell.addSubview(img)
        cell.addSubview(label)
        

        return cell
    }
    
    func shadowchange(img:UIImageView){
        let num:CGFloat = -1
        UIView.animateWithDuration(2, animations: {
            () -> Void in
            img.layer.shadowOffset = CGSize(width: num, height: num)
            }, completion: {
                (Bool) -> Void in
                img.layer.shadowOffset = CGSize(width: -num, height: -num)
        })
        
    }
    
    var loginAlert:UIAlertController!
    //MARK: 不同跳转页面的配置
    func jumptofuncview(sender: UITapGestureRecognizer){
        let img = sender.view as! UIImageView
        shadowchange(img)
        let segue = item[img.tag]["action"]
        if let segue = segue{
            switch(segue){
            case "weather":
                self.performSegueWithIdentifier(segue, sender: self)
            case "course":
                loginAlert = funcalert("请输入教务系统登录账户密码")
                loginAlert.addTextFieldWithConfigurationHandler({ (textfield:UITextField!) -> Void in
                    textfield.delegate = self
                    textfield.placeholder = "请输入密码"
                    textfield.secureTextEntry = true
                    textfield.tag = 1
                })
                let loginAction = self.loginAction("getcourse")
                loginAlert.addAction(loginAction)
                presentViewController(loginAlert, animated: true, completion: nil)
            case "cet":
                loginAlert = funcalert("请输入CET准考证号以及姓名")
                loginAlert.addTextFieldWithConfigurationHandler({ (textfield:UITextField!) -> Void in
                    textfield.delegate = self
                    textfield.placeholder = "请输入姓名"
                    textfield.tag = 2
                })
                loginAlert.textFields![0].placeholder = "请输入准考证号"
                let loginAction = self.loginAction("getcet")
                loginAlert.addAction(loginAction)
                presentViewController(loginAlert, animated: true, completion: nil)
            case "score":
                loginAlert = funcalert("请输入教务系统登录账户密码")
                loginAlert.addTextFieldWithConfigurationHandler({ (textfield:UITextField!) -> Void in
                    textfield.delegate = self
                    textfield.placeholder = "请输入密码"
                    textfield.secureTextEntry = true
                    textfield.tag = 3
                })
                let loginAction = self.loginAction("getscore")
                loginAlert.addAction(loginAction)
                presentViewController(loginAlert, animated: true, completion: nil)
            default:
                print("当前segue："+segue)
            }
            
        }
    }
    
    func getcet(id:String,name:String){
        do{
            var strUrl = "cet?data={\"id\":\"\(id)\",\"name\":\"\(name)\"}"
            strUrl = ip + strUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            let url = NSURL(string:strUrl)
            let data = try NSData(contentsOfURL:url!,options: NSDataReadingOptions())
            json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            let statu = String(json!.objectForKey("status")!)
            dismissViewControllerAnimated(false, completion: {
                ()->Void in
                if statu=="success"{
                    let result = self.json as! NSDictionary
                    var longstr = ""
                    for key in result.allKeys{
                        longstr = longstr+String(key)+":"+String(result[String(key)]!)+"\n"
                    }
                    
                    self.warnalert(longstr)
                }else{
                    self.warnalert("查询失败，请检查输入的信息")
                }
            })
        }catch{
            dismissViewControllerAnimated(false, completion: {
                ()->Void in
                self.warnalert("访问时遇到未知错误！")
            })
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField.tag{
        case 1:
            self.login(loginAlert, function: "getcourse")
        case 2:
            self.login(loginAlert, function: "getcet")
        case 3:
            self.login(loginAlert, function: "getscore")
        default:
            print("文本框ID：\(textField.tag)，未找到此ID对应的方法")
        }
        return true
    }
    
    func login(loginAlert:UIAlertController,function:String){
        let loginid = loginAlert.textFields![0].text!
        let loginpassword = loginAlert.textFields![1].text!
        if loginid == ""{
            loginAlert.dismissViewControllerAnimated(true, completion: nil)
            self.warnalert("用户名不能为空")
        }else if loginpassword == ""{
            loginAlert.dismissViewControllerAnimated(true, completion: nil)
            self.warnalert("密码不能为空")
        }else{
            loginAlert.dismissViewControllerAnimated(false, completion: nil)
            let avialert = self.avialert("正在查询")
            self.presentViewController(avialert, animated: true, completion: {
                ()->Void in
                if function == "getscore"{
                    self.getscore(loginid, pwd: loginpassword)
                }else if function == "getcourse"{
                    self.getcourse(loginid,pwd: loginpassword)
                }else if function == "getcet"{
                    self.getcet(loginid, name: loginpassword)
                }else{
                    print("未找到此function")
                }
            })
        }
    }
    
    //获取分数并跳转
    func getscore(id:String,pwd:String){
        do{
            var strUrl = "score?data={\"username\":\"\(id)\",\"password\":\"\(pwd)\"}"
            strUrl = ip + strUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            let url = NSURL(string:strUrl)
            let data = try NSData(contentsOfURL:url!,options: NSDataReadingOptions())
            json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            let statu = String(json!.objectForKey("status")!)
            dismissViewControllerAnimated(false, completion: {
                ()->Void in
                if statu=="success"{
                    self.performSegueWithIdentifier("score", sender: self)
                }else{
                    self.warnalert("用户名或密码错误")
                }
            })
        }catch{
            dismissViewControllerAnimated(false, completion: {
                ()->Void in
                self.warnalert("访问时遇到未知错误！")
            })
            print(error)
        }
    }
    
    //获取课程并跳转
    func getcourse(id:String,pwd:String){
        do{
            var strUrl = "course?data={\"username\":\"\(id)\",\"password\":\"\(pwd)\"}"
            strUrl = ip + strUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            let url = NSURL(string:strUrl)
            let data = try NSData(contentsOfURL:url!,options: NSDataReadingOptions())
            json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            let statu = String(json!.objectForKey("status")!)
            dismissViewControllerAnimated(false, completion: {
            ()->Void in
                if statu=="success"{
                    self.performSegueWithIdentifier("course", sender: self)
                }else{
                    self.warnalert("用户名或密码错误")
                }
            })
        }catch{
            dismissViewControllerAnimated(false, completion: {
                ()->Void in
                self.warnalert("访问时遇到未知错误！")
            })
            print(error)
        }
    }
    
    //MARK: 弹窗设置
    
    //进行中提示弹窗
    func avialert(message:String) -> UIAlertController{
        let alert = UIAlertController(title: "提示", message: message+"\n\n", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "好", style: .Default, handler: {
            (UIAlertAction) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        })
        alert.addAction(ok)
        let avi = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        avi.color = UIColor.blackColor()
        avi.center = CGPointMake(self.view.center.x-53, 90)
        avi.startAnimating()
        alert.view.addSubview(avi)
        return alert
    }
    //复用警告弹窗
    func warnalert(message:String){
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "好", style: .Default, handler: nil)
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
    }
    //复用功能弹窗（带好按钮、一个文本框、一个密码框）
    func funcalert(message:String) -> UIAlertController{
        let loginForCourseAlert = UIAlertController(title: "提示", message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "取消", style: .Default, handler: nil)
        loginForCourseAlert.addTextFieldWithConfigurationHandler({(textfield:UITextField!) -> Void in
            textfield.placeholder = "请输入用户名"
        })
        
        loginForCourseAlert.addAction(cancelAction)
        return loginForCourseAlert
    }
    //复用弹窗按钮－登录
    func loginAction(function:String) -> UIAlertAction{
        
        let loginAction = UIAlertAction(title: "登录", style: .Default, handler: {
            (UIAlertAction) -> Void in
            self.login(self.loginAlert, function: function)
            
        })
        return loginAction
    }
    

    
    
    //MARK: 页面跳转前的准备（传值）
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "course"{
            let courseVC = segue.destinationViewController as! CourseViewController
            courseVC.json = self.json
        }else if segue.identifier == "score"{
            let scoreVC = segue.destinationViewController as! ScoreViewController
            scoreVC.datas = self.json!["datas"] as! NSArray
            scoreVC.credit = self.json!["sumCredit"] as! String
            scoreVC.gpa = self.json!["gpa"] as! String
            scoreVC.name = self.json!["name"] as! String
        }
    }

}
