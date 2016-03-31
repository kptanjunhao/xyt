//
//  LoginViewController.swift
//  newxyt
//
//  Created by 谭钧豪 on 16/2/3.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    //
    var userdefault = NSUserDefaults.standardUserDefaults()
    var action = "login?data="
    //用户密码输入框
    var txtUser:UITextField!
    var txtPwd:UITextField!
    var autologin:UISwitch!
    var loginBtn:UIButton!
    
    //左手离脑袋的距离
    var offsetLeftHand:CGFloat = 60
    
    //左手图片,右手图片(遮眼睛的)
    var imgLeftHand:UIImageView!
    var imgRightHand:UIImageView!
    
    //左手图片,右手图片(圆形的)
    var imgLeftHandGone:UIImageView!
    var imgRightHandGone:UIImageView!
    
    //当前遮眼状态
    var isshelted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem(title: "注销", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item;
        
        //获取屏幕尺寸
        let mainSize = UIScreen.mainScreen().bounds.size
        //设置背景
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "loginbg")!)
        
        //猫头鹰头部
        let imgLogin =  UIImageView(frame:CGRectMake(mainSize.width/2-211/2, 100, 211, 109))
        imgLogin.image = UIImage(named:"owl-login")
        imgLogin.layer.masksToBounds = true
        self.view.addSubview(imgLogin)
        
        //猫头鹰左手(遮眼睛的)
        let rectLeftHand = CGRectMake(61 - offsetLeftHand, 90, 40, 65)
        imgLeftHand = UIImageView(frame:rectLeftHand)
        imgLeftHand.image = UIImage(named:"owl-login-arm-left")
        imgLogin.addSubview(imgLeftHand)
        
        //猫头鹰右手(遮眼睛的)
        let rectRightHand = CGRectMake(imgLogin.frame.size.width / 2 + 60, 90, 40, 65)
        imgRightHand = UIImageView(frame:rectRightHand)
        imgRightHand.image = UIImage(named:"owl-login-arm-right")
        imgLogin.addSubview(imgRightHand)
        
        //登录框背景
        let vLogin =  UIView(frame:CGRectMake(15, 200, mainSize.width - 30, 200))
        vLogin.layer.borderWidth = 0.5
        vLogin.layer.borderColor = UIColor.lightGrayColor().CGColor
        vLogin.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(vLogin)
        
        //猫头鹰左手(圆形的)
        let rectLeftHandGone = CGRectMake(mainSize.width / 2 - 100,
            vLogin.frame.origin.y - 22, 40, 40)
        imgLeftHandGone = UIImageView(frame:rectLeftHandGone)
        imgLeftHandGone.image = UIImage(named:"icon_hand")
        self.view.addSubview(imgLeftHandGone)
        
        //猫头鹰右手(圆形的)
        let rectRightHandGone = CGRectMake(mainSize.width / 2 + 62,
            vLogin.frame.origin.y - 22, 40, 40)
        imgRightHandGone = UIImageView(frame:rectRightHandGone)
        imgRightHandGone.image = UIImage(named:"icon_hand")
        self.view.addSubview(imgRightHandGone)
        
        //用户名输入框
        txtUser = UITextField(frame:CGRectMake(30, 30, vLogin.frame.size.width - 60, 44))
        txtUser.delegate = self
        txtUser.layer.cornerRadius = 5
        txtUser.layer.borderColor = UIColor.lightGrayColor().CGColor
        txtUser.layer.borderWidth = 0.5
        txtUser.leftView = UIView(frame:CGRectMake(0, 0, 44, 44))
        txtUser.leftViewMode = UITextFieldViewMode.Always
        txtUser.keyboardType = .ASCIICapable
        txtUser.returnKeyType = .Next
        txtUser.autocorrectionType = .No
        txtUser.autocapitalizationType = .None
        txtUser.clearButtonMode = .WhileEditing
        
        //用户名输入框左侧图标
        let imgUser =  UIImageView(frame:CGRectMake(11, 11, 22, 22))
        imgUser.image = UIImage(named:"iconfont-user")
        txtUser.leftView!.addSubview(imgUser)
        vLogin.addSubview(txtUser)
        
        //密码输入框
        txtPwd = UITextField(frame:CGRectMake(30, 90, vLogin.frame.size.width - 60, 44))
        txtPwd.delegate = self
        txtPwd.layer.cornerRadius = 5
        txtPwd.layer.borderColor = UIColor.lightGrayColor().CGColor
        txtPwd.layer.borderWidth = 0.5
        txtPwd.secureTextEntry = true
        txtPwd.leftView = UIView(frame:CGRectMake(0, 0, 44, 44))
        txtPwd.leftViewMode = UITextFieldViewMode.Always
        txtPwd.returnKeyType = .Go
        txtPwd.clearButtonMode = .WhileEditing
        
        //密码输入框左侧图标
        let imgPwd =  UIImageView(frame:CGRectMake(11, 11, 22, 22))
        imgPwd.image = UIImage(named:"iconfont-password")
        txtPwd.leftView!.addSubview(imgPwd)
        vLogin.addSubview(txtPwd)
        
        //登陆选项
        autologin = UISwitch(frame: CGRectMake(100,150,10,11))
        autologin.transform = CGAffineTransformMakeScale(0.75, 0.75)
        autologin.addTarget(self, action: #selector(LoginViewController.saveconfig(_:)), forControlEvents: .ValueChanged)
        let saveconfigbool = userdefault.boolForKey("autologin")
        if saveconfigbool && userdefault.valueForKey("username") as? String != ""{
            autologin.setOn(saveconfigbool, animated: false)
            txtUser.text = userdefault.valueForKey("username") as? String
            txtPwd.text = userdefault.valueForKey("userpassword") as? String
        }
        vLogin.addSubview(autologin)
        
        
        let saveuserlabel = UILabel(frame: CGRectMake(30,150,70,28))
        saveuserlabel.text = "自动登录"
        saveuserlabel.font = UIFont.systemFontOfSize(15)
        vLogin.addSubview(saveuserlabel)
        
        
        loginBtn = UIButton(frame: CGRectMake(vLogin.frame.size.width-85,150,55,30))
        loginBtn.setTitle("登录", forState: .Normal)
        loginBtn.layer.cornerRadius = 8
        loginBtn.backgroundColor = UIColor(red: 0, green: 128/255, blue: 1, alpha: 1)
        loginBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginBtn.addTarget(self, action: #selector(LoginViewController.login), forControlEvents: .TouchUpInside)
        vLogin.addSubview(loginBtn)
        
        if let loginstatu = userdefault.valueForKey("autologin"){
            if (loginstatu as! Bool){
                login()
            }else{
            }
        }
        
    }
    
    //输入框获取焦点开始编辑
    func textFieldDidBeginEditing(textField:UITextField)
    {
        //如果当前是用户名输入
        if textField.isEqual(txtUser){

            
            //播放不遮眼动画
            UIView.animateWithDuration(0.5, animations: removehand())
        }
            //如果当前是密码名输入
        else if textField.isEqual(txtPwd){
            
            //播放遮眼动画
            UIView.animateWithDuration(0.5, animations: sheltereyes())
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(txtUser.isFirstResponder()){
            txtUser.resignFirstResponder()
        }else if(txtPwd.isFirstResponder()){
            txtPwd.resignFirstResponder()
            UIView.animateWithDuration(0.5, animations: removehand())
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.isEqual(txtUser){
            txtPwd.becomeFirstResponder()
        }else if textField.isEqual(txtPwd){
            login()
            txtPwd.resignFirstResponder()
            UIView.animateWithDuration(0.5, animations: removehand())
        }
        return true
    }
    
    func saveconfig(sender:UISwitch){
        if sender.on{
            userdefault.setBool(sender.on, forKey: "autologin")
        }else{
            userdefault.setBool(sender.on, forKey: "autologin")
        }
    }
    

    
    func login(){
        if(txtUser.isFirstResponder()){
            txtUser.resignFirstResponder()
        }else if(txtPwd.isFirstResponder()){
            txtPwd.resignFirstResponder()
            UIView.animateWithDuration(0.5, animations: removehand())
        }
        if txtUser.text! != "" && txtPwd.text! != ""{
            if autologin.on{
                userdefault.setValue(txtUser.text!, forKey: "username")
                userdefault.setValue(txtPwd.text!, forKey: "userpassword")
            }
            
            
            func logining() -> ()->Void{
                return{
                    self.loginBtn.setTitle("正在登录", forState: .Normal)
                    self.loginBtn.enabled = false
                    self.loginBtn.frame = CGRectMake(self.loginBtn.frame.origin.x-20,
                        self.loginBtn.frame.origin.y, self.loginBtn.frame.width+20, self.loginBtn.frame.height)
                }
            }
            
            func cannotlogining() -> ()->Void{
                return{
                    self.loginBtn.setTitle("", forState: .Normal)
                    self.loginBtn.enabled = true
                    self.loginBtn.frame = CGRectMake(self.loginBtn.frame.origin.x+20,
                        self.loginBtn.frame.origin.y, self.loginBtn.frame.width-20, self.loginBtn.frame.height)
                }
            }

            
            UIView.animateWithDuration(0.5, animations: logining())
            //访问网络登录
            var url = "{\"username\":\"\(txtUser.text!)\",\"password\":\"\(txtPwd.text!)\"}"
            print(Config.ip)
            url = Config.ip + self.action + url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet())!
            var statu = ""
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                //花费时间的代码块
                let request = NSURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 3.0)
                let session = NSURLSession.sharedSession()
                let semaphore = dispatch_semaphore_create(0)
                let dataTask = session.dataTaskWithRequest(request, completionHandler: {
                    (data, response, error) -> Void in
                    if error != nil{
                        statu = "Error"
                    }else{
                        do{
                            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                            statu = String(json.objectForKey("status")!)
                        }catch{print("解析出错")
                        print(error)}
                    }
                    dispatch_semaphore_signal(semaphore)
                    
                }) as NSURLSessionTask
                
                dataTask.resume()//启动线程
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)//等待线程结束
                
                dispatch_async(dispatch_get_main_queue(), {
                    //主线程代码块
                    
                    UIView.animateWithDuration(0.2, animations: cannotlogining(), completion: {
                        (Bool)->Void in
                        self.loginBtn.setTitle("登录", forState: .Normal)
                    })
                    
                    switch(statu){
                    case "－1":
                        self.addwarning("访问服务器的参数出错啦，请联系程序猿修改", statu: false)
                    case "0":
                        self.addwarning("用户名或密码错误",statu: false)
                    case "1":
                        self.userdefault.setValue(self.txtUser.text!, forKey: "username")
                        self.addwarning("登录成功",statu: true)
                    default:
                        self.addwarning("无法连接至服务器", statu: false)
                    }
                    
                })
            })

            
        }else{
            addwarning("用户名或密码不能为空", statu: false)
        }
    }
    
    func addwarning(message:String,statu:Bool){
        let warning = UIAlertController(title: "提示", message: message, preferredStyle: .Alert)
        let CancelAction = UIAlertAction(title: "好", style: UIAlertActionStyle.Cancel, handler:nil)
        warning.addAction(CancelAction)
        if statu == true{
            self.presentViewController(warning, animated: true, completion: {
                () ->Void in
                self.userdefault.setValue(true, forKey: "iflogin")
                self.presentedViewController?.dismissViewControllerAnimated(false, completion: {
                    self.performSegueWithIdentifier("loginsuccess", sender: self)
                })
            })
        }else{
            self.presentViewController(warning, animated: true, completion: nil)
        }
    }
    
    
    func removehand() -> ()->Void{
        if isshelted == true{
            isshelted = false
            return{
                self.imgLeftHand.frame = CGRectMake(
                    self.imgLeftHand.frame.origin.x - self.offsetLeftHand,
                    self.imgLeftHand.frame.origin.y + 30,
                    self.imgLeftHand.frame.size.width, self.imgLeftHand.frame.size.height)
                self.imgRightHand.frame = CGRectMake(
                    self.imgRightHand.frame.origin.x + 48,
                    self.imgRightHand.frame.origin.y + 30,
                    self.imgRightHand.frame.size.width, self.imgRightHand.frame.size.height)
                self.imgLeftHandGone.frame = CGRectMake(
                    self.imgLeftHandGone.frame.origin.x - 70,
                    self.imgLeftHandGone.frame.origin.y, 40, 40)
                self.imgRightHandGone.frame = CGRectMake(
                    self.imgRightHandGone.frame.origin.x + 30,
                    self.imgRightHandGone.frame.origin.y, 40, 40)
            }
        }else{
            return {}
        }
    }
    
    func sheltereyes() -> ()->Void{
        if isshelted == false{
            isshelted = true
            return{
                self.imgLeftHand.frame = CGRectMake(
                    self.imgLeftHand.frame.origin.x + self.offsetLeftHand,
                    self.imgLeftHand.frame.origin.y - 30,
                    self.imgLeftHand.frame.size.width, self.imgLeftHand.frame.size.height)
                self.imgRightHand.frame = CGRectMake(
                    self.imgRightHand.frame.origin.x - 48,
                    self.imgRightHand.frame.origin.y - 30,
                    self.imgRightHand.frame.size.width, self.imgRightHand.frame.size.height)
                self.imgLeftHandGone.frame = CGRectMake(
                    self.imgLeftHandGone.frame.origin.x + 70,
                    self.imgLeftHandGone.frame.origin.y, 0, 0)
                self.imgRightHandGone.frame = CGRectMake(
                    self.imgRightHandGone.frame.origin.x - 30,
                    self.imgRightHandGone.frame.origin.y, 0, 0)
            }
        }else{
            return {}
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSUserDefaults.standardUserDefaults().setValue(false, forKey: "iflogin")
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loginsuccess"{
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
