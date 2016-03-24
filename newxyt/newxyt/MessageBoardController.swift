//
//  MessageBoardController.swift
//  newxyt
//
//  Created by 谭钧豪 on 16/3/10.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

class MessageBoardController: UITableViewController, UITextFieldDelegate {
    let ip = NSUserDefaults.standardUserDefaults().valueForKey("ip") as! String
    var userid = ""
    var loginstatu = false
    var messages = NSMutableArray()
    var halftableViewHeight:CGFloat!
    var defaultSectionCount = 5
    var SectionCount = NSMutableDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let uid = NSUserDefaults.standardUserDefaults().valueForKey("username"){
            self.userid = uid as! String
        }
        halftableViewHeight = self.tableView.frame.size.height/2
        self.navigationController?.title = "留言板"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if messages.count == 0{
            let none = NSMutableArray()
            none.addObject(["text":""])
            messages.addObject(none)
            return 1
        }
        return messages.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let sectionSet = SectionCount[section]{
            let count = (sectionSet as! NSArray)[0] as! Int
            let ableToShowAll = (sectionSet as! NSArray)[1] as! Bool
            if count != 1{
                if count > self.defaultSectionCount{
                    return  ableToShowAll ? count : self.defaultSectionCount
                }else{
                    return count
                }
            }else{
                return 0
            }
        }else{
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = UITableViewHeaderFooterView()
        
        let msgtitle = (((messages[section] as! NSArray)[0] as! NSDictionary)["text"]) as! String
        var msgtime = ""
        var fromwho = "还没有人给你留言噢。"
        if let msgdatetime = ((messages[section] as! NSArray)[0] as! NSDictionary)["datetime"]{
            let date = NSDate(timeIntervalSince1970: (msgdatetime as! Double)/1000.0)
            let dateformater = NSDateFormatter()
            dateformater.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
            msgtime = dateformater.stringFromDate(date)
            fromwho = ((messages[section] as! NSArray)[0] as! NSDictionary)["messagefrom"] as! String
        }
        
        
        let titlelabel = UILabel(frame: CGRectMake(10,50,self.view.frame.width-20,30))
        titlelabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        titlelabel.numberOfLines = 0
        titlelabel.text = msgtitle
        titlelabel.textColor = UIColor.blackColor()
        let timelabel = UILabel(frame: CGRectMake(60,20,200,30))
        timelabel.text = msgtime
        timelabel.textColor = UIColor(red: 0.68, green: 0.68, blue: 0.68, alpha: 1)
        timelabel.font = UIFont.systemFontOfSize(12)
        let fromlabel = UILabel(frame: CGRectMake(60,0,200,30))
        fromlabel.text = fromwho
        fromlabel.textColor = UIColor.blackColor()
        fromlabel.font = UIFont.boldSystemFontOfSize(18)
        let sectionHeight = titlelabel.frame.height
        sectionHeaderView.frame = CGRectMake(0, 0, self.view.frame.width, sectionHeight)
        sectionHeaderView.addSubview(titlelabel)
        sectionHeaderView.addSubview(fromlabel)
        sectionHeaderView.addSubview(timelabel)
        let BGFrame = CGRectMake(sectionHeaderView.frame.origin.x+5, sectionHeaderView.frame.origin.y+5, sectionHeaderView.frame.width-10, sectionHeaderView.frame.height-10)
        let sectionBGView = UIView(frame: BGFrame)
        sectionBGView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).CGColor
        sectionBGView.layer.cornerRadius = 10
        sectionBGView.layer.borderWidth = 1
        sectionBGView.backgroundColor = UIColor.whiteColor()
        sectionHeaderView.backgroundView = sectionBGView
        return sectionHeaderView
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let sectionSet = SectionCount[section]{
            var footerViewHeight:CGFloat = 50
            if ((sectionSet as! NSArray)[0] as! Int) > 5{
                footerViewHeight = 70
            }else{
                
            }
            let sectionFooterView = UITableViewHeaderFooterView(frame: CGRectMake(0,0,self.view.frame.width,footerViewHeight))
            let sectionBGView = UIView()
            sectionBGView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
            let replybtn = UIButton(frame: CGRectMake(self.view.frame.width-70,30,60,30))
            replybtn.tag = section
            replybtn.layer.cornerRadius = 8
            replybtn.backgroundColor = UIColor(red:0.09, green:0.53, blue:0.95, alpha:1)
            replybtn.setTitle("回复", forState: .Normal)
            replybtn.addTarget(self, action: #selector(MessageBoardController.reply(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            let replytextf = UITextField(frame: CGRectMake(10, 30, self.view.frame.width-90, 30))
            replytextf.tag = section+1
            replytextf.layer.cornerRadius = 5
            replytextf.backgroundColor = UIColor.whiteColor()
            replytextf.placeholder = "我也说一句"
            replytextf.delegate = self
            if footerViewHeight > 50{
                let clicktoview = UILabel(frame: CGRectMake(10,5,130,20))
                clicktoview.tag = section
                clicktoview.font = UIFont.systemFontOfSize(12)
                clicktoview.text = (sectionSet as! NSArray)[1] as! Bool ? "收起" : "点击展开全部回复"
                clicktoview.textColor = UIColor(red:0.24, green:0.67, blue:1, alpha:1)
                clicktoview.userInteractionEnabled = true
                let taptoview = UITapGestureRecognizer(target: self, action:
                    #selector(MessageBoardController.expandOrContract(_:)))
                clicktoview.addGestureRecognizer(taptoview)
                sectionFooterView.addSubview(clicktoview)
            }
            sectionFooterView.backgroundView = sectionBGView
            sectionFooterView.addSubview(replytextf)
            sectionFooterView.addSubview(replybtn)
            
            return sectionFooterView
        }else{
            return nil
        }
        
    }
    
    func expandOrContract(sender:UITapGestureRecognizer){
        let expendOrContractSection = (sender.view!.tag)
        let sectionSet = SectionCount[expendOrContractSection] as! NSArray
        let count = sectionSet[0] as! Int
        let ableToShowAll = sectionSet[1] as! Bool
        let newset = [count,!ableToShowAll]
        self.SectionCount.addEntriesFromDictionary([expendOrContractSection:newset])
        self.tableView.reloadData()
    }
    
    func reply(sender:UIButton){
        let section = sender.tag
        if let curView = sender.superview{
            let textfield = curView.viewWithTag(section+1) as! UITextField
            textfield.resignFirstResponder()
            let content = textfield.text
            let towho = (((messages[section] as! NSArray)[0] as! NSDictionary)["messageto"]) as! String
            let messageid = (((messages[section] as! NSArray)[0] as! NSDictionary)["id"]) as! Int
            let action = "replymessage?data="
            let paras:NSMutableDictionary = [
                "messagefrom" : userid,
                "messageto" : towho,
                "text" : content!,
                "messageid" : messageid
            ]
            print(paras)
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
                    let warning = UIAlertController(title: "提示", message: "提交出错", preferredStyle: .Alert)
                    let ok = UIAlertAction(title: "好", style: .Default, handler: nil)
                    warning.addAction(ok)
                    self.presentViewController(warning, animated: true, completion: nil)
                }else{
                    do{
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSNumber
                        if json == 0{
                            let alert = UIAlertController(title: "提示", message: "回复成功", preferredStyle: .Alert)
                            let ok = UIAlertAction(title: "好", style: .Default, handler: {
                                (OK) -> Void in
                                self.getMsg()
                            })
                            alert.addAction(ok)
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                        
                        
                    }catch{print("解析出错")}
                }
                dispatch_semaphore_signal(semaphore)
                
            }) as NSURLSessionTask
            
            dataTask.resume()//启动线程
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)//等待线程结束
        }
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if self.tableView.frame.height != halftableViewHeight{
            UIView.animateWithDuration(0.5, animations: {
                self.tableView.frame.size.height = self.halftableViewHeight + 64
            })
        }
        let section = textField.tag-1
        let sectionSet = SectionCount[section] as! NSArray
        let count = sectionSet[0] as! Int
        let ableToShowAll = sectionSet[1] as! Bool
        var row = 0
        if count != 1{
            row = ableToShowAll ? count-1 : defaultSectionCount-1
        }else{
            row = 0
        }
        let indexPath = NSIndexPath(forRow: row, inSection: section)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if self.tableView.frame.height != 2*halftableViewHeight{
            UIView.animateWithDuration(0.5, animations: {
                self.tableView.frame.size.height = 2*self.halftableViewHeight - 64
            })
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.tableView.becomeFirstResponder()
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let sectionSet = SectionCount[section]{
            if ((sectionSet as! NSArray)[0] as! Int) > 5{
                return 70
            }else{
                return 50
            }
        }else{
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    override func viewWillAppear(animated: Bool) {
        loginstatu = NSUserDefaults.standardUserDefaults().valueForKey("iflogin") as! Bool
        if !loginstatu{
            messages = NSMutableArray()
            self.tableView.reloadData()
            let warning = UIAlertController(title: "提示", message: "请先登录", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "好", style: UIAlertActionStyle.Default, handler: { (OK) -> Void in
                warning.dismissViewControllerAnimated(true, completion: nil)
                self.tabBarController?.selectedIndex = 0
            })
            warning.addAction(okAction)
            presentViewController(warning, animated: true, completion: nil)
        }else{
            getMsg()
        }
    }

    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellfont = UIFont.systemFontOfSize(12)
        let cell = UITableViewCell(frame: CGRectMake(0, 0, self.view.frame.width, 40))
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.separatorInset = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0)
        let nameView = UIView(frame: CGRectMake(10,2,90,36))
        nameView.layer.cornerRadius = 8
        nameView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).CGColor
        nameView.layer.borderWidth = 1
        let towholabel = UILabel(frame: CGRectMake(30,16,120,20))
        towholabel.font = cellfont
        towholabel.text = (((messages[indexPath.section] as! NSArray)[indexPath.row+1] as! NSDictionary)["messageto"]) as? String
        let fromwholabel = UILabel(frame: CGRectMake(8,0,120,20))
        fromwholabel.font = cellfont
        fromwholabel.text = (((messages[indexPath.section] as! NSArray)[indexPath.row+1] as! NSDictionary)["messagefrom"]) as? String
        let replytxtlabel = UILabel(frame: CGRectMake(10,10,50,20))
        replytxtlabel.font = UIFont.systemFontOfSize(10)
        replytxtlabel.text = "回复"
        replytxtlabel.textColor = UIColor(red: 0.68, green: 0.68, blue: 0.68, alpha: 1)
        let content = UILabel(frame: CGRectMake(100,5,200,30))
        content.font = cellfont
        content.lineBreakMode = NSLineBreakMode.ByWordWrapping
        content.numberOfLines = 0
        content.text = (((messages[indexPath.section] as! NSArray)[indexPath.row+1] as! NSDictionary)["text"]) as? String
        nameView.addSubview(towholabel)
        nameView.addSubview(fromwholabel)
        nameView.addSubview(replytxtlabel)
        cell.addSubview(nameView)
        cell.addSubview(content)
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    func getMsg(){
        let action = "getmessagestome?data="
        var url = "{\"userid\":\"\(userid)\"}"
        url = ip + action + url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet())!
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let request = NSURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5.0)
            let session = NSURLSession.sharedSession()
            let semaphore = dispatch_semaphore_create(0)
            let datatask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                if error != nil{
                    print(error)
                }else{
                    do{
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                        let msgs = json.objectForKey("datas") as? NSMutableArray
                        if msgs != nil{
                            self.messages = msgs!
                            var section = 0
                            for message in self.messages{
                                let curSectionSet = [(message as! NSArray).count-1,false]
                                self.SectionCount.addEntriesFromDictionary([section:curSectionSet])
                                section += 1
                            }
                        }else{
                            self.messages = NSMutableArray()
                        }
                        
                    }catch{
                        print(error)
                    }
                }
                dispatch_semaphore_signal(semaphore)
            })
            datatask.resume()
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        })
        
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
