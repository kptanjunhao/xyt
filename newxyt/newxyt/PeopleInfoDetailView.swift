//
//  PeopleInfoDetailView.swift
//  newxyt
//
//  Created by 谭钧豪 on 16/2/5.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit
import AFNetworking

class CellMenuItem: UIMenuItem{
    var indexPath: NSIndexPath!
}

class PeopleInfoDetailView: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var people = Friend()
    var iconView:UIImageView!
    var intend:UIBarButtonSystemItem!
    var friendInfo = [String:AnyObject]()
    let ip = NSUserDefaults.standardUserDefaults().valueForKey("ip") as! String
    let userid = NSUserDefaults.standardUserDefaults().valueForKey("username")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var rightbaraction = "Add"
        var item:UIBarButtonItem!
        
        let leavemsgbtn = UIButton(type: UIButtonType.System)
        leavemsgbtn.frame = CGRectMake(self.tableView.frame.size.width/2 - 120, self.tableView.frame.height/2 + 170, 100, 30)
        leavemsgbtn.setTitle("给TA留言", forState: .Normal)
        leavemsgbtn.backgroundColor = UIColor(red:0.24, green:0.67, blue:1, alpha:0.8)
        leavemsgbtn.layer.cornerRadius = 10
        leavemsgbtn.addTarget(self, action: #selector(PeopleInfoDetailView.leavemsg), forControlEvents: .TouchUpInside)
        if intend == UIBarButtonSystemItem.Trash{
            item = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
            let deletebtn = UIButton(type: UIButtonType.System)
            deletebtn.frame = CGRectMake(self.tableView.frame.size.width/2 + 20, self.tableView.frame.height/2 + 170, 100, 30)
            deletebtn.setTitle("删除好友", forState: .Normal)
            deletebtn.tintColor = UIColor.whiteColor()
            deletebtn.backgroundColor = UIColor(red:1, green:0.3, blue:0.25, alpha:1)
            deletebtn.layer.cornerRadius = 10
            deletebtn.addTarget(self, action: #selector(PeopleInfoDetailView.Delete), forControlEvents: .TouchUpInside)
            self.tableView.addSubview(deletebtn)
            self.tableView.addSubview(leavemsgbtn)
        }else if intend == UIBarButtonSystemItem.Done{
            rightbaraction = "Done"
            item = UIBarButtonItem(barButtonSystemItem: intend, target: self, action: Selector(rightbaraction))
            people.userid = userid as! String
            
        }else{
            let addbtn = UIButton(type: UIButtonType.System)
            addbtn.frame = CGRectMake(self.tableView.frame.size.width/2 + 20, self.tableView.frame.height/2 + 170, 100, 30)
            addbtn.setTitle("添加好友", forState: .Normal)
            addbtn.tintColor = UIColor.whiteColor()
            addbtn.backgroundColor = UIColor(red:0.32, green:0.8, blue:0.94, alpha:1)
            addbtn.layer.cornerRadius = 10
            addbtn.addTarget(self, action: #selector(PeopleInfoDetailView.Add), forControlEvents: .TouchUpInside)
            self.tableView.addSubview(addbtn)
            self.tableView.addSubview(leavemsgbtn)
        }
        
        self.navigationItem.rightBarButtonItem = item
        let FriendInfo = data()
        for attr in people.allattr{
            friendInfo[attr] = FriendInfo.objectForKey(attr)
        }
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func leavemsg(){
        let leavemsgAlert = UIAlertController(title: "留言", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        leavemsgAlert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "给他讲两句"
        }
        let ok = UIAlertAction(title: "发送", style: UIAlertActionStyle.Default) { (ok) -> Void in
            let alert2 = UIAlertController(title: "提示", message: "发送中", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "好", style: UIAlertActionStyle.Default, handler: nil)
            alert2.addAction(okAction)
            self.presentViewController(alert2, animated: true, completion: {
                //from to text
                let action = "leavemessage?data="
                let friendid = String(self.friendInfo["userid"]!)
                var url = "{\"from\":\"\(self.userid!)\",\"to\":\"\(friendid)\",\"text\":\"\(leavemsgAlert.textFields![0].text!)\"}"
                url = self.ip + action + url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                self.request(url)
                
                
            })
        }
        leavemsgAlert.addAction(ok)
        let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        leavemsgAlert.addAction(cancel)
        presentViewController(leavemsgAlert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friendInfo.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row != 0{
            return 40
        }else{
            return 100
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row != 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("friendInfoCell", forIndexPath: indexPath) as! FriendInfoCell
            let attr = people.allattr[indexPath.row]
            cell.attrLabel.text = people.attrname[attr]
            if people.userid != userid as! String{
                let longtap = UILongPressGestureRecognizer(target: self, action: #selector(PeopleInfoDetailView.display(_:)))
                longtap.minimumPressDuration = 0.5
                cell.valueLabel.addGestureRecognizer(longtap)
                cell.valueLabel.userInteractionEnabled = true
                if let friendInfoAttr = friendInfo[attr]{
                    cell.valueLabel.text = String(friendInfoAttr)
                }else{
                    cell.valueLabel.text = ""
                }
            }else{
                let tfframe = CGRectMake(cell.valueLabel.frame.origin.x, cell.valueLabel.frame.origin.y-5, self.view.frame.width/3*2, cell.valueLabel.frame.height+10)
                let valuetf = UITextField(frame: tfframe)
                valuetf.tag = indexPath.row
                valuetf.delegate = self
                if let friendInfoAttr = friendInfo[attr]{
                    valuetf.text = String(friendInfoAttr)
                }else{
                    valuetf.text = ""
                }
                valuetf.layer.borderColor = UIColor.grayColor().CGColor
                valuetf.layer.borderWidth = 1
                valuetf.layer.cornerRadius = 5
                cell.addSubview(valuetf)
                cell.valueLabel.removeFromSuperview()
            }
            return cell
        }else{
            let cell = UITableViewCell()
            iconView = UIImageView()
            iconView.userInteractionEnabled = true
            let iconurl = people.usericon
            iconView.setZYHWebImage(iconurl, defaultImage: "people", isCache: true)
            iconView.frame = CGRectMake(cell.frame.width/2 - 20, 10, 80, 80)
            cell.addSubview(iconView)
            if people.userid == userid as! String{
                //添加修改头像
                let icontap = UITapGestureRecognizer(target: self, action: #selector(PeopleInfoDetailView.changeicon(_:)))
                iconView.addGestureRecognizer(icontap)
            }
            return cell
        }
        
    }
    
    func changeicon(sender:UITapGestureRecognizer){
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            //设置是否允许编辑
            picker.allowsEditing = true
            //弹出控制器，显示界面
            self.presentViewController(picker, animated: true, completion: {
                () -> Void in
            })
        }else{
            print("读取相册错误")
        }
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            //获取选择的原图
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            iconView.image = image
            //图片控制器退出
            picker.dismissViewControllerAnimated(true, completion: {
                () -> Void in
            })
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        setnewvalue(textField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        setnewvalue(textField)
        return true
    }
    
    func setnewvalue(textField: UITextField){
        friendInfo[people.allattr[textField.tag]] = textField.text
        print(friendInfo)
    }
    
    
    func Add(){
        let friendid = String(friendInfo["userid"]!)
        let action = "addFriend?data="
        var url = "{\"petitor\":\"\(userid!)\",\"receiver\":\"\(friendid)\"}"
        url = ip + action + url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let warning = UIAlertController(title: "提示", message: "将向对方发送好友邀请", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "确定", style: .Cancel, handler: {
            (UIAlertAction) ->Void in
            self.request(url)
            
        })
        let cancelAction = UIAlertAction(title: "取消", style: .Default, handler: nil)
        warning.addAction(okAction)
        warning.addAction(cancelAction)
        presentViewController(warning, animated: true, completion: nil)
    }
    
    func Delete(){
        let friendid = String(friendInfo["userid"]!)
        let action = "deletefriend?data="
        var url = "{\"username\":\"\(userid!)\",\"friend\":\"\(friendid)\"}"
        url = ip + action + url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let warning = UIAlertController(title: "警告", message: "确认删除你的好友吗？", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Destructive , handler: {
            (UIAlertAction) ->Void in
            self.request(url)
        })
        let cancelAction = UIAlertAction(title: "取消", style: .Default, handler: nil)
        warning.addAction(okAction)
        warning.addAction(cancelAction)
        presentViewController(warning, animated: true, completion: nil)
    }
    
    func Done(){
        self.becomeFirstResponder()
        print(friendInfo)
        print("进入资料修改提交")
        updateicon(iconView.image!)
    }
    
    func updateicon(icon:UIImage){
        let iconjpg = UIImageJPEGRepresentation(icon, 0.95)
        print(iconjpg?.length)
        let session = NSURLSession.sharedSession()
        let semaphore = dispatch_semaphore_create(0)
        let url = NSURL(string: ip+"uploadface")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
        let body = NSMutableData()
        body.appendData(NSString(string: "username=\(userid!)").dataUsingEncoding(NSUTF8StringEncoding)!)
//        body.appendData(NSString(string: "\r\n----------------------2121222222222222222222\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
//        body.appendData(NSString(string: "Content-Disposition:form-data;name=\"jpg\";filename=\"1001\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
//        body.appendData(NSString(string: "Content-Type;application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(string: "jpg=\(iconjpg!)").dataUsingEncoding(NSUTF8StringEncoding)!)
//        body.appendData(NSString(string: "\r\n----------------------2121222222222222222222\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        
        request.HTTPBody = body
        
        let dataTask = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            if error != nil{
                print("获取出错")
                print(error)
            }else{
                do{
                    let statustr = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSNumber
                    print(statustr)
                    
                }catch{print("解析出错")}
            }
            dispatch_semaphore_signal(semaphore)
            
        }) as NSURLSessionTask
        dataTask.resume()//启动线程
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)//等待线程结束
        let tip = UIAlertController(title: "提示", message: "", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "好", style: .Default, handler: {
            (OK) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        })
        tip.addAction(OKAction)
        presentViewController(tip, animated: true, completion: nil)
    }
    
//    func updateicon(icon:UIImage){
//        let manager = AFHTTPRequestOperationManager()
//        let iconjpg = UIImageJPEGRepresentation(icon, 0.95)
//        let para = [
//            "username":userid!,
//            "jpg":iconjpg!
//        ]
//        manager.POST(ip+"uploadface", parameters: para, success: { (AFHTTPRequestOperation, data) -> Void in
//            print(data)
//            }) { (AFHTTPRequestOperation, error) -> Void in
//                print(error)
//        }
//
//        
//    }
    
    func request(url:String){
        var statu = 1
//        let request = NSMutableURLRequest(URL:NSURL(string:url)!,cachePolicy:NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData,timeoutInterval:2.0)
        let request = NSMutableURLRequest(URL: NSURL(string:url)!)
        request.HTTPMethod = "POST"
        let session = NSURLSession.sharedSession()
        let semaphore = dispatch_semaphore_create(0)
        print(request.HTTPMethod)
        let dataTask = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            if error != nil{
                print("获取出错")
                print(error)
            }else{
                do{
                    let statustr = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSNumber
                    print(statustr)
                    statu = statustr.integerValue
                    
                }catch{print("解析出错")}
            }
            dispatch_semaphore_signal(semaphore)
            
        }) as NSURLSessionTask
        dataTask.resume()//启动线程
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)//等待线程结束
        let tip = UIAlertController(title: "提示", message: "", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "好", style: .Default, handler: {
            (OK) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        })
        tip.addAction(OKAction)
        if statu == 0 {
            tip.message = "成功"
        }else if statu == 3{
            tip.message = "你曾经发送过邀请，请等候对方接受"
        }else{
            tip.message = "操作失败，请联系管理员"
        }
        presentViewController(tip, animated: true, completion: nil)
    }
    
    func data() -> AnyObject {
        
        
        let action = "profile?data="
        let username = people.userid
        var datas:AnyObject?
        var url = "{\"username\":\"\(username)\"}"
        
        url = ip + action + url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet())!
        let request = NSURLRequest(URL:NSURL(string:url)!,cachePolicy:NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData,timeoutInterval:10.0)
        let session = NSURLSession.sharedSession()
        let semaphore = dispatch_semaphore_create(0)
        let dataTask = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            if error != nil{print("获取出错")
            }else{
                do{
                    datas = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    
                    
                }catch{print("解析出错")}
            }
            dispatch_semaphore_signal(semaphore)
            
        }) as NSURLSessionTask
        
        dataTask.resume()//启动线程
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)//等待线程结束
        return datas!
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func canResignFirstResponder() -> Bool {
        return true
    }
    

    
    
    func copyLine(menuController: UIMenuController) {
        let menuItem: CellMenuItem = UIMenuController.sharedMenuController().menuItems![0] as! CellMenuItem
        if menuItem.indexPath != nil {
            let value = String(friendInfo[people.allattr[menuItem.indexPath.row]]!)
            let pasteboard = UIPasteboard.generalPasteboard()
            pasteboard.string = value
        }
    }
    
    //end menu delegate
    
    //action handler of longPressGesture
    func display(gesture: UILongPressGestureRecognizer)
    {
        if gesture.state == UIGestureRecognizerState.Began{
            gesture.view?.becomeFirstResponder()
            let pressedIndexPath = self.tableView.indexPathForRowAtPoint(gesture.locationInView(self.tableView))
            let menu = UIMenuController.sharedMenuController()
            let copyItem = CellMenuItem(title: "复制", action: #selector(PeopleInfoDetailView.copyLine(_:)))
            copyItem.indexPath = pressedIndexPath
            menu.menuItems = [copyItem]
            var cellRect = self.tableView.rectForRowAtIndexPath(pressedIndexPath!)
            cellRect.origin.x = cellRect.origin.x - 10.0
            cellRect.origin.y = cellRect.origin.y + 20.0
            menu.setTargetRect(cellRect, inView: self.tableView)
            menu.setMenuVisible(true, animated: true)
        }
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
