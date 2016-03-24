//
//  CreateMSGViewController.swift
//  newxyt
//
//  Created by 谭钧豪 on 16/3/9.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit
import AFNetworking

class CreateMSGLine: UIView {
    override func drawRect(rect:CGRect){
        let context =  UIGraphicsGetCurrentContext();//获取画笔上下文
        CGContextSetAllowsAntialiasing(context, true) //抗锯齿设置
        //画直线0
        CGContextSetLineWidth(context, 1) //设置画笔宽度
        CGContextSetRGBStrokeColor(context, 0.66, 0.66, 0.66, 1)
        CGContextMoveToPoint(context,0, 44);
        CGContextAddLineToPoint(context,rect.width, 44);
        CGContextStrokePath(context)
        //画直线1
        CGContextSetLineWidth(context, 1) //设置画笔宽度
        CGContextSetRGBStrokeColor(context, 0.66, 0.66, 0.66, 1)
        CGContextMoveToPoint(context,0, 88);
        CGContextAddLineToPoint(context,rect.width, 88);
        CGContextStrokePath(context)
    }
}


class CreateMSGViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    let ip = String(NSUserDefaults.standardUserDefaults().valueForKey("ip")!)
    let username = String(NSUserDefaults.standardUserDefaults().valueForKey("username")!)
    
    var titletf:UITextField!
    var recpeopletf:UITextField!
    var contenttv:UITextView!
    var selectView:UITableView!
    var selectStatus = false
    var finishtouch:UIButton!
    var sendbtn:UIButton!
    var sendbtnframe:CGRect!
    
    var groupnamelist = [String]()
    var groups:NSArray!
    var sendpeoples = NSMutableArray()
    var sectionopen = [Int:Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titlelabel = UILabel(frame: CGRectMake(15,7,75,30))
        titlelabel.text = "标题："
        titlelabel.textColor = UIColor.lightGrayColor()
        self.view.addSubview(titlelabel)
        let recpeople = UILabel(frame: CGRectMake(15,51,100,30))
        recpeople.text = "收件人："
        recpeople.textColor = UIColor.lightGrayColor()
        self.view.addSubview(recpeople)
        let recpeopletouch = UIButton(frame: CGRectMake(100,44,self.view.frame.width-170,44))
        recpeopletouch.backgroundColor = UIColor.clearColor()
        recpeopletouch.addTarget(self, action: #selector(CreateMSGViewController.selectpeople), forControlEvents: .TouchUpInside)
        
        finishtouch = UIButton(frame: CGRectMake(self.view.frame.width+10,51,60,30))
        finishtouch.layer.cornerRadius = 8
        finishtouch.backgroundColor = UIColor(red:0.09, green:0.53, blue:0.95, alpha:1)
        finishtouch.addTarget(self, action: #selector(CreateMSGViewController.selectpeople), forControlEvents: .TouchUpInside)
        finishtouch.setTitle("完成", forState: .Normal)
        
        sendbtnframe = CGRectMake(20,self.view.frame.height - 101 - (self.tabBarController?.tabBar.frame.height ?? 0),self.view.frame.width - 40,30)
        sendbtn = UIButton(frame: sendbtnframe)
        sendbtn.layer.cornerRadius = 10
        sendbtn.setTitle("发送", forState: .Normal)
        sendbtn.backgroundColor = UIColor(red:0.09, green:0.53, blue:0.95, alpha:1)
        sendbtn.addTarget(self, action: #selector(CreateMSGViewController.sendmsg), forControlEvents: .TouchUpInside)
        
        
        
        selectView = UITableView(frame: CGRectMake(0,self.view.frame.height,self.view.frame.width,self.view.frame.height-88), style: UITableViewStyle.Plain)
        selectView.backgroundColor = UIColor.whiteColor()
        selectView.dataSource = self
        selectView.delegate = self
        
        titletf = UITextField(frame: CGRectMake(95,7,self.view.frame.width-105,30))
        titletf.placeholder = "请输入标题"
        titletf.addTarget(self, action: #selector(CreateMSGViewController.titleeditbegin), forControlEvents: .EditingDidBegin)
        titletf.addTarget(self, action: #selector(CreateMSGViewController.titleeditend), forControlEvents: .EditingDidEnd)
        recpeopletf = UITextField(frame: CGRectMake(95,51,self.view.frame.width-105,30))
        recpeopletf.userInteractionEnabled = false
        self.view.addSubview(titletf)
        self.view.addSubview(recpeopletf)
        self.view.addSubview(recpeopletouch)
        
        
        contenttv = UITextView(frame: CGRectMake(14, 95, self.view.frame.width-28, self.view.frame.height-250))
        contenttv.layer.borderWidth = 1
        contenttv.layer.borderColor = UIColor.lightGrayColor().CGColor
        contenttv.delegate = self
        self.view.addSubview(contenttv)
        
        self.view.addSubview(selectView)
        self.view.addSubview(sendbtn)
        self.view.addSubview(finishtouch)
        groups = getContacts()
        
        // Do any additional setup after loading the view.
    }
    
    func titleeditbegin(){
        editing(true)
    }
    
    func titleeditend(){
        editing(false)
    }
    func sendmsg(){
        let action = "publish?data="
        let paras:NSMutableDictionary = [
                "person" : sendpeoples,
                "status" : -1,
                "username" : username,
                "publish" : [
                    "title" : titletf.text!,
                    "content" : contenttv.text
                ]
            ]
        var parasdata:NSData!
        do{
            parasdata = try NSJSONSerialization.dataWithJSONObject(paras, options: NSJSONWritingOptions.PrettyPrinted)
        }catch{
            print(error)
        }
        let personString = NSString(data: parasdata, encoding: NSUTF8StringEncoding)
        var url = "\(personString!)"
        url = ip + action + url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet())!
        print(url)
        let request = NSMutableURLRequest(URL:NSURL(string:url)!,cachePolicy:NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData,timeoutInterval:5.0)
        request.HTTPMethod = "POST"
        let session = NSURLSession.sharedSession()
        let semaphore = dispatch_semaphore_create(0)
        let dataTask = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            if error != nil{
                let warning = UIAlertController(title: "提示", message: "出错", preferredStyle: .Alert)
                let ok = UIAlertAction(title: "好", style: .Default, handler: nil)
                warning.addAction(ok)
                self.presentViewController(warning, animated: true, completion: nil)
            }else{
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    print(json)
                    
                    
                }catch{print("解析出错")}
            }
            dispatch_semaphore_signal(semaphore)
            
        }) as NSURLSessionTask
        
        dataTask.resume()//启动线程
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)//等待线程结束
    }
    
    func selectpeople(){
        contenttv.resignFirstResponder()
        UIView.animateWithDuration(0.2, animations: {
            self.selectView.frame.origin.y = !self.selectStatus ? 88 : self.view.frame.height
            self.finishtouch.frame.origin.x = self.selectStatus ? self.view.frame.width+10 : self.view.frame.width-70
            },completion:{
                (Bool) -> Void in
                self.selectStatus = !self.selectStatus
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return groups.count
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let openTap = UITapGestureRecognizer(target: self, action: #selector(CreateMSGViewController.openSection(_:)))
        let sectionView = UIView(frame: CGRectMake(0,0,self.selectView.frame.width,30))
        sectionView.tag = section
        sectionView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1)
        let sectionTitle = UILabel(frame: CGRectMake(15,0,250,30))
        sectionTitle.font = UIFont.systemFontOfSize(15)
        sectionTitle.text = (groups[section] as! Group).groupname + "（共\((groups[section] as! Group).friends.count)人）"
        sectionView.addSubview(sectionTitle)
        if (groups[section] as! Group).friends.count != 0{
            sectionView.addGestureRecognizer(openTap)
            let selectall = UIButton(frame: CGRectMake(sectionView.frame.width - 75,4,60,22))
            selectall.setTitle("添加整组", forState: .Normal)
            selectall.titleLabel?.font = UIFont.systemFontOfSize(12)
            selectall.layer.cornerRadius = 5
            selectall.tag = section
            selectall.addTarget(self, action: #selector(CreateMSGViewController.sectionTap(_:)), forControlEvents: .TouchUpInside)
            selectall.backgroundColor = UIColor(red:0, green:0.7, blue:0.87, alpha:1)
            sectionView.addSubview(selectall)
        }
        return sectionView
    }
    
    func openSection(sender:UITapGestureRecognizer){
        let sectionView = sender.view!
        sectionopen[sectionView.tag] = !(sectionopen[sectionView.tag]!)
        var indexPaths = [NSIndexPath]()
        for i in 0...(groups[sectionView.tag] as! Group).friends.count-1{
            let indexPath = NSIndexPath(forRow: i, inSection: sectionView.tag)
            indexPaths.append(indexPath)
        }
        selectView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        
    }
    
    func updatenumofsendpeople(){
        recpeopletf.text = "当前已选择\(self.sendpeoples.count)人"
    }
    
    
    func sectionTap(sender:UIButton){
        let section = sender.tag
        if sender.currentTitle == "添加整组"{
            sender.setTitle("取消选择", forState: .Normal)
            var i = 0
            for friend in (groups[section] as! Group).friends{
                let indexPath = NSIndexPath(forRow: i, inSection: section)
                let selectlbl = selectView.cellForRowAtIndexPath(indexPath)?.viewWithTag(18) as! UILabel
                if !(friend as! Friend).selected{
                    (friend as! Friend).selected = true
                    selectlbl.text = "已选择"
                    sendpeoples.addObject(["username":(friend as! Friend).userid])
                }
                i += 1
            }
        }else{
            sender.setTitle("添加整组", forState: .Normal)
            var i = 0
            for friend in (groups[section] as! Group).friends{
                let indexPath = NSIndexPath(forRow: i, inSection: section)
                let selectlbl = selectView.cellForRowAtIndexPath(indexPath)?.viewWithTag(18) as! UILabel
                if (friend as! Friend).selected{
                    (friend as! Friend).selected = false
                    selectlbl.text = ""
                    sendpeoples.removeObject(["username":(friend as! Friend).userid])
                }
                i += 1
            }
        }
        updatenumofsendpeople()
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return sectionopen[indexPath.section]! ? 30 : 0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (groups[section] as! Group).friends.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectlbl = selectView.cellForRowAtIndexPath(indexPath)?.viewWithTag(18) as! UILabel
        if selectlbl.text != "已选择"{
            selectlbl.text = "已选择"
            (((groups[indexPath.section] as! Group).friends)[indexPath.row] as! Friend).selected = true
            sendpeoples.addObject(["username":(((groups[indexPath.section] as! Group).friends)[indexPath.row] as! Friend).userid])
        }else{
            selectlbl.text = ""
            (((groups[indexPath.section] as! Group).friends)[indexPath.row] as! Friend).selected = false
            sendpeoples.removeObject(["username":(((groups[indexPath.section] as! Group).friends)[indexPath.row] as! Friend).userid])
        }
        updatenumofsendpeople()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let selectedLabel = UILabel(frame: CGRectMake(cell.frame.width-20,0,45,30))
        selectedLabel.tag = 18
        selectedLabel.text = (((groups[indexPath.section] as! Group).friends)[indexPath.row] as! Friend).selected ? "已选择" : ""
        selectedLabel.font = UIFont.systemFontOfSize(12)
        cell.addSubview(selectedLabel)
        let namelbl = UILabel(frame: CGRectMake(15,0,100,30))
        namelbl.tag = 8
        namelbl.textColor = UIColor.blackColor()
        namelbl.backgroundColor = UIColor.redColor()
        namelbl.text = (((groups[indexPath.section] as! Group).friends)[indexPath.row] as! Friend).realname
        cell.addSubview(namelbl)
        return cell
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        contenttv.resignFirstResponder()
        titletf.resignFirstResponder()
    }
    
    func editing(isediting:Bool){
        if isediting{
            UIView.animateWithDuration(0.5, animations: {
                self.sendbtn.frame = CGRectMake(self.view.frame.width-70,51, 60, 30)
                self.contenttv.frame.size.height -= self.view.frame.height/3
            })
        }else{
            UIView.animateWithDuration(0.5, animations: {
                self.sendbtn.frame = self.sendbtnframe
                self.contenttv.frame.size.height += self.view.frame.height/3
            })
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        editing(true)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        editing(false)
    }
    
    func getContacts() -> NSArray {
        let action = "groups?data="
        var url = "{\"username\":\"\(username)\"}"
        var datas = NSMutableArray()
        url = ip + action + url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet())!
        let request = NSURLRequest(URL:NSURL(string:url)!,cachePolicy:NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData,timeoutInterval:10.0)
        let session = NSURLSession.sharedSession()
        let semaphore = dispatch_semaphore_create(0)
        let dataTask = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            if error != nil{
                let warning = UIAlertController(title: "提示", message: "获取列表出错", preferredStyle: .Alert)
                let ok = UIAlertAction(title: "好", style: .Default, handler: nil)
                warning.addAction(ok)
                self.presentViewController(warning, animated: true, completion: nil)
            }else{
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    let groupnamelist = json.objectForKey("groupNameList")!
                    datas = NSMutableArray(capacity: groupnamelist.count)
                    
                    for groupcount in 0..<groupnamelist.count{
                        self.sectionopen[groupcount] = false
                        let group:Group = Group()
                        group.groupname = groupnamelist[groupcount]!.objectForKey("groupName")! as! String
                        self.groupnamelist.append(group.groupname)
                        let friendlist = json.objectForKey(group.groupname)!
                        let friends = NSMutableArray(capacity: friendlist.count)
                        for friendcount in 0..<friendlist.count{
                            let friend:Friend = Friend()
                            friend.setValuesForKeysWithDictionary(["realname":(friendlist[friendcount]!.objectForKey("realname")! as! String)])
                            friend.setValuesForKeysWithDictionary(["userid":(friendlist[friendcount]!.objectForKey("username")! as! String)])
                            friend.setValuesForKeysWithDictionary(["phone":(friendlist[friendcount]!.objectForKey("phone")! as! String)])
                            friends.addObject(friend)
                        }
                        group.friends = friends
                        datas.addObject(group)
                    }
                    
                    
                }catch{print("解析出错")}
            }
            dispatch_semaphore_signal(semaphore)
            
        }) as NSURLSessionTask
        
        dataTask.resume()//启动线程
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)//等待线程结束
        return datas
    }
}
