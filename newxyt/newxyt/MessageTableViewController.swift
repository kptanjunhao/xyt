//
//  MessageTableViewController.swift
//  logintest1
//
//  Created by 钧豪 谭 on 15/12/11.
//  Copyright © 2015年 钧豪 谭. All rights reserved.
//

import UIKit



class MessageTableViewController: UITableViewController {
    
    var action = "recmsgs?data="
    var datas:NSMutableArray?
    var msgs = NSArray()
    var selectedrow:Int = NSNotFound
    
    
    
    @IBOutlet weak var segmentedconrol: UISegmentedControl!
    @IBAction func segmentedcontrol(sender: UISegmentedControl) {
        switch(segmentedconrol.selectedSegmentIndex){
        case 0:
            action = "recmsgs?data="
        case 1:
            action = "sendmsgs?data="
        default:
            action = "recmsgs?data="
        }
        msgs = data()
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        msgs = data()
        
        let item = UIBarButtonItem(title: "发起通知", style: UIBarButtonItemStyle.Done, target: self, action: #selector(MessageTableViewController.createmsg))
        self.navigationItem.rightBarButtonItem = item
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        msgs = data()
        tableView.reloadData()
    }
    
    func createmsg(){
        self.performSegueWithIdentifier("createmsg", sender: self)
    }
    
    func data() -> NSArray {
        
        
        let ip = String(NSUserDefaults.standardUserDefaults().valueForKey("ip")!)
        let username = String(NSUserDefaults.standardUserDefaults().valueForKey("username")!)
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
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    let msglist = json.objectForKey("datas")!
                    self.datas = NSMutableArray(capacity: msglist.count)
                    for msgcount in 0..<msglist.count{
                        
                        
                        if self.action == "recmsgs?data="{
                            let flag = String(msglist[msgcount]!.objectForKey("flag")!)
                            let msg:Message = Message()
                            msg.title = msglist[msgcount]!.objectForKey("title")! as! String
                            msg.noticeid = String(msglist[msgcount]!.objectForKey("noticeid")!)
                            msg.time = msglist[msgcount]!.objectForKey("time")! as! String
                            msg.flag = flag
                            self.datas!.addObject(msg)
                        }else if self.action == "sendmsgs?data="{
                            let msg:Message = Message()
                            msg.title = msglist[msgcount]!.objectForKey("title")! as! String
                            msg.noticeid = String(msglist[msgcount]!.objectForKey("noticeid")!)
                            msg.time = msglist[msgcount]!.objectForKey("time")! as! String
                            msg.noticegroup = String(msglist[msgcount]!.objectForKey("noticegroup")!)
                            self.datas!.addObject(msg)
                        }

                        
                    }
                    
                    
                }catch{
                    self.datas = NSMutableArray(capacity: 1)
                    print("解析出错")
                    let msg:Message = Message()
                    msg.title = "访问出错"
                    msg.noticeid = ""
                    msg.time = ""
                    msg.flag = ""
                    self.datas!.addObject(msg)
                }
            }
            dispatch_semaphore_signal(semaphore)
            
        }) as NSURLSessionTask
        
        dataTask.resume()//启动线程
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)//等待线程结束
        return datas!
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
        return msgs.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("msgCell", forIndexPath: indexPath) as! MsgsCell
        
        cell.msg =  msgs[indexPath.row] as! Message
        
        if cell.msg.title == "访问出错"{
            cell.timeLabel.text = ""
            cell.statuLabel.text = ""
            cell.titleLabel.text = "访问出错"
            cell.userInteractionEnabled = false
        }else{
            cell.setmsg(cell.msg)
            cell.userInteractionEnabled = true
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedrow = indexPath.row
        self.performSegueWithIdentifier("msgdetail", sender: self)
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "msgdetail"{
            let msgdetailview = segue.destinationViewController as! MsgDetailViewController
            msgdetailview.noticeid = (msgs[selectedrow] as! Message).noticeid
            msgdetailview.noticegroup = (msgs[selectedrow] as! Message).noticegroup
            msgdetailview.flag = (msgs[selectedrow] as! Message).flag
            if segmentedconrol.selectedSegmentIndex == 0{
                msgdetailview.isrec = true
            }else{
                msgdetailview.isrec = false
            }
        }
    }
    

}
