//
//  ContactView.swift
//  newxyt
//
//  Created by 谭钧豪 on 16/2/4.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit
import Foundation
import BTNavigationDropdownMenu

// 定义了用户组以及FriendCell的一系列属性、方法
class SectionInfo: NSObject {
    var group: Group = Group()
    var headerView: SectionHeaderView = SectionHeaderView()
}

class RecentTap: UITapGestureRecognizer {
    var tag:Int!
}

class ContactView: UIViewController, UITableViewDataSource, UITableViewDelegate, SectionHeaderViewDelegate {
    var AddBtn: UIBarButtonItem!
    var editbtn: UIBarButtonItem!
    
    var refreshControl = UIRefreshControl()
    var ContactTableView: UITableView!
    var RecentTableView: UITableView!
    var Contacts:NSArray!
    var RecentFriends:NSMutableArray!
    var groupnamelist = [String]()
    var opensectionindex = NSNotFound
    var sectionInfoArray:NSMutableArray!
    var selectedfriend = Friend()
    var menuView:BTNavigationDropdownMenu!
    var tochange = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tempfs = NSUserDefaults.standardUserDefaults().objectForKey("RecentFriends"){
            RecentFriends = NSMutableArray(array: tempfs as! NSMutableArray)
        }else{
            RecentFriends = NSMutableArray(capacity: 10)
        }
        var tableframe = self.view.frame
        tableframe.origin.x = tableframe.origin.x - 15
        tableframe.size.width = tableframe.width + 15
        tableframe.origin.y = tableframe.origin.y
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        editbtn = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(ContactView.edit))
        AddBtn = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ContactView.addFriend))
        self.navigationItem.rightBarButtonItems = [AddBtn]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let items = ["所有好友", "最近好友", "资料修改", "查看通知"]
        self.navigationController?.navigationBar.translucent = false
        UINavigationBar.appearance().translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: "所有好友", items: items)
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = UIColor(red: 0.0/255.0, green:160.0/255.0, blue:195.0/255.0, alpha: 1.0)
        menuView.cellTextLabelColor = UIColor.whiteColor()
        menuView.cellSeparatorColor = UIColor.blackColor()
        menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.3
        menuView.maskBackgroundColor = UIColor.blackColor()
        menuView.maskBackgroundOpacity = 0.3
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            switch(indexPath){
            case 0:
                self.navigationItem.rightBarButtonItems = [self.AddBtn]
                self.changeTableView(true)
            case 1:
                self.navigationItem.rightBarButtonItems = [self.editbtn]
                self.RecentTableView.reloadData()
                self.changeTableView(false)
            case 2:
                self.tochange = true
                self.performSegueWithIdentifier("frienddetail", sender: self)
            case 3:
                self.performSegueWithIdentifier("message", sender: self)
            default:
                self.navigationItem.rightBarButtonItems = [self.AddBtn]
                self.changeTableView(true)
            }
        }
        

        self.navigationItem.titleView = menuView
        
        ContactTableView = UITableView(frame: tableframe, style: .Plain)
        ContactTableView.delegate = self
        ContactTableView.dataSource = self
        ContactTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        ContactTableView.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        RecentTableView = UITableView(frame: tableframe, style: .Plain)
        RecentTableView.delegate = self
        RecentTableView.dataSource = self
        RecentTableView.scrollsToTop = false
        
        RecentTableView.hidden = true
        
        Contacts = getContacts()
        self.view.addSubview(ContactTableView)
        self.view.addSubview(RecentTableView)
        
        

        let sectionHeaderNib: UINib = UINib(nibName: "SectionHeaderView", bundle: nil)
        ContactTableView.registerNib(sectionHeaderNib, forHeaderFooterViewReuseIdentifier: "SectionHeaderViewIdentifier")
        
        
        
        //添加刷新
        refreshControl.addTarget(self, action: #selector(ContactView.refresh),
            forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        ContactTableView.addSubview(refreshControl)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Refresh Data
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if !refreshControl.refreshing {
            refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        }
    }
    
    func refresh(){
        if opensectionindex != NSNotFound{
            refreshControl.attributedTitle = NSAttributedString(string: "数据加载中...")
            let sectionInfo: SectionInfo = self.sectionInfoArray[opensectionindex] as! SectionInfo
            sectionInfo.headerView.HeaderOpen = false
            sectionInfo.headerView.BtnDisclosure.selected = false
            let countOfRowsToDelete = ContactTableView.numberOfRowsInSection(opensectionindex)
            if countOfRowsToDelete > 0 {
                var indexPathsToDelete = [NSIndexPath]()
                for i in 0 ..< countOfRowsToDelete {
                    indexPathsToDelete.append(NSIndexPath(forRow: i, inSection: opensectionindex))
                }
                ContactTableView.beginUpdates()
                ContactTableView.deleteRowsAtIndexPaths(indexPathsToDelete, withRowAnimation: .Middle)
                ContactTableView.endUpdates()
            }
            opensectionindex = NSNotFound
            groupnamelist.removeAll()
            Contacts = getContacts()
            ContactTableView.reloadData()
            refreshControl.endRefreshing()
        }else{
            refreshControl.attributedTitle = NSAttributedString(string: "数据加载中...")
            groupnamelist.removeAll()
            Contacts = getContacts()
            ContactTableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    //设置最近好友
    func setRF(friend:Friend){
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        let tempfriend = ["name":friend.realname,
            "phone":friend.phone,
            "id":friend.userid,
            "time":"查看"+timeFormatter.stringFromDate(NSDate())
        ]
        if RecentFriends.count == 0{
            RecentFriends.addObject(tempfriend)
        }else{
            var hasrepeat = false
            for friendindex in 0...RecentFriends.count-1{
                if ((RecentFriends[friendindex]["name"]) as! String) ==  tempfriend["name"]!{
                    RecentFriends.removeObjectAtIndex(friendindex)
                    RecentFriends.addObject(tempfriend)
                    hasrepeat = true
                    break
                }
            }
            if !hasrepeat{
                if RecentFriends.count <= 10{
                    RecentFriends.addObject(tempfriend)
                }else{
                    RecentFriends.removeObjectAtIndex(0)
                    RecentFriends.addObject(tempfriend)
                }
            }
        }
        NSUserDefaults.standardUserDefaults().setObject(RecentFriends, forKey: "RecentFriends")
    }
    
    //最近好友表编辑状态
    var editstatu = true
    func edit(){
        RecentTableView.editing = editstatu
        editstatu = !editstatu
    }
    
    //添加好友
    func addFriend(){
        performSegueWithIdentifier("toAddFriend", sender: self)
    }
    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if tableView == RecentTableView{
            return 1
        }
        return groupnamelist.count
    }
    
    func sectionHeaderView(sectionHeaderView: SectionHeaderView, sectionOpened: Int) {
        let sectionInfo: SectionInfo = sectionInfoArray[sectionOpened] as! SectionInfo
        sectionInfo.headerView.HeaderOpen = true
        //创建一个包含单元格索引路径的数组来实现插入单元格的操作：这些路径对应当前节的每个单元格
        let countOfRowsToInsert = sectionInfo.group.friends.count
        let indexPathsToInsert = NSMutableArray()
        for i in 0 ..< countOfRowsToInsert {
            indexPathsToInsert.addObject(NSIndexPath(forRow: i, inSection: sectionOpened))
        }
        // 创建一个包含单元格索引路径的数组来实现删除单元格的操作：这些路径对应之前打开的节的单元格
        let indexPathsToDelete = NSMutableArray()
        let previousOpenSectionIndex = opensectionindex
        if previousOpenSectionIndex != NSNotFound {
            let previousOpenSection: SectionInfo = sectionInfoArray[previousOpenSectionIndex] as! SectionInfo
            previousOpenSection.headerView.HeaderOpen = false
            previousOpenSection.headerView.toggleOpen(false)
            let countOfRowsToDelete = previousOpenSection.group.friends.count
            for i in 0 ..< countOfRowsToDelete {
                indexPathsToDelete.addObject(NSIndexPath(forRow: i, inSection: previousOpenSectionIndex))
            }
        }

        // 应用单元格的更新
        let tableView = ContactTableView
        
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths(indexPathsToDelete as [AnyObject] as! [NSIndexPath], withRowAnimation: .Fade)
        tableView.insertRowsAtIndexPaths(indexPathsToInsert as [AnyObject] as! [NSIndexPath], withRowAnimation: .Automatic)
        opensectionindex = sectionOpened
        tableView.endUpdates()
    }
    
    func sectionHeaderView(sectionHeaderView: SectionHeaderView, sectionClosed: Int) {
        // 在表格关闭的时候，创建一个包含单元格索引路径的数组，接下来从表格中删除这些行
        let sectionInfo: SectionInfo = self.sectionInfoArray[sectionClosed] as! SectionInfo
        sectionInfo.headerView.HeaderOpen = false
        let countOfRowsToDelete = ContactTableView.numberOfRowsInSection(sectionClosed)
        if countOfRowsToDelete > 0 {
            var indexPathsToDelete = [NSIndexPath]()
            for i in 0 ..< countOfRowsToDelete {
                indexPathsToDelete.append(NSIndexPath(forRow: i, inSection: sectionClosed))
            }
            ContactTableView.deleteRowsAtIndexPaths(indexPathsToDelete, withRowAnimation: .Fade)
        }
        opensectionindex = NSNotFound
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 返回指定的section header视图
        let sectionHeaderView: SectionHeaderView = ContactTableView.dequeueReusableHeaderFooterViewWithIdentifier("SectionHeaderViewIdentifier") as! SectionHeaderView
        let sectionInfo: SectionInfo = sectionInfoArray[section] as! SectionInfo
        sectionInfo.headerView = sectionHeaderView
        sectionHeaderView.LblTitle.text = groupnamelist[section]+"(共\((Contacts[section] as! Group).friends.count)人)"
        sectionHeaderView.section = section
        sectionHeaderView.delegate = self
        let bgView = UIView(frame: sectionHeaderView.frame)
        bgView.backgroundColor = UIColor.whiteColor()
        sectionHeaderView.backgroundView = bgView
        return sectionHeaderView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == ContactTableView{
            return 40
        }else{
            return 0
        }
    }
    

    

    //返回当前分组的好友数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if tableView == RecentTableView{
            return RecentFriends.count
        }
        let sectionInfo: SectionInfo = self.sectionInfoArray[section] as! SectionInfo
        let numStoriesInSection = (Contacts[section] as! Group).friends.count
        let sectionOpen = sectionInfo.headerView.HeaderOpen
        return sectionOpen ? numStoriesInSection : 0
    }
    
    //返回高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return 60
    }
    
    
    //返回tableview右边section的索引(太丑暂时不加)
//    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
//        return groupnamelist
//    }
    
    
    //MARK: 配置Cell
    var nameLabelFrame = CGRectMake(70, 10, 100, 20)
    var signLabelFrame = CGRectMake(70, 35, 200, 20)
    var CellSeparate = UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 0)
    let iconfont = UIFont(name: "iconfont", size: 34)
    let iconcolor = UIColor(red: 0, green: 128/255, blue: 1, alpha: 1)
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let namelbl = UILabel(frame: nameLabelFrame)
        namelbl.font = UIFont.systemFontOfSize(18)
        let signlbl = UILabel(frame: signLabelFrame)
        signlbl.font = UIFont.systemFontOfSize(14)
        let iconView = UIImageView()
        var iconurl = ""
        cell.addSubview(iconView)
        if tableView == ContactTableView{
            iconurl = ((Contacts[indexPath.section] as! Group).friends[indexPath.row] as! Friend).usericon
            cell.separatorInset = CellSeparate
            namelbl.text = ((Contacts[indexPath.section] as! Group).friends[indexPath.row] as! Friend).realname
            signlbl.text = ((Contacts[indexPath.section] as! Group).friends[indexPath.row] as! Friend).signature
        }else{
            iconurl = Config.ip + "faces/" + (RecentFriends[RecentFriends.count-1-indexPath.row]["id"]! as! String) + ".jpg"
            let msgicon = UILabel(frame: CGRectMake(cell.frame.width,cell.center.y-10,40,40))
            msgicon.userInteractionEnabled = true
            msgicon.font = iconfont
            msgicon.textColor = iconcolor
            let phoneicon = UILabel(frame: CGRectMake(cell.frame.width-48,cell.center.y-10,40,40))
            phoneicon.userInteractionEnabled = true
            phoneicon.font = iconfont
            phoneicon.textColor = iconcolor
            phoneicon.tag = indexPath.row
            msgicon.tag = indexPath.row
            phoneicon.text = "\u{e6d6}"
            msgicon.text = "\u{e660}"
            let calltap = RecentTap(target: self, action: #selector(ContactView.callphone(_:)))
            calltap.tag = RecentFriends.count-1-indexPath.row
            phoneicon.addGestureRecognizer(calltap)
            let msgtap = RecentTap(target: self, action: #selector(ContactView.sendmsg(_:)))
            msgtap.tag = RecentFriends.count-1-indexPath.row
            msgicon.addGestureRecognizer(msgtap)
            cell.contentView.addSubview(phoneicon)
            cell.contentView.addSubview(msgicon)
            cell.separatorInset = UIEdgeInsetsZero
            namelbl.text = RecentFriends[RecentFriends.count-1-indexPath.row]["name"] as? String
            signlbl.text = RecentFriends[RecentFriends.count-1-indexPath.row]["time"] as? String
        }
        iconView.setZYHWebImage(iconurl, defaultImage: "people", isCache: true)
        iconView.frame = CGRectMake(20, 10, 40, 40)
        signlbl.textColor = UIColor.grayColor()
        cell.contentView.addSubview(signlbl)
        cell.contentView.addSubview(namelbl)
        return cell
    }
    
    //选中cell时的动作
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == ContactTableView{
            selectedfriend = (Contacts[indexPath.section] as! Group).friends[indexPath.row] as! Friend
            tableView.cellForRowAtIndexPath(indexPath)?.selected = false
            setRF(selectedfriend)
            performSegueWithIdentifier("frienddetail", sender: self)
        }else{
            
        }
    }
    
    //返回表格是否可以编辑
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if tableView == RecentTableView{
            return true
        }else{
            return false
        }
    }
    //提交编辑结束时的动作
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            RecentFriends.removeObjectAtIndex(RecentFriends.count-1-indexPath.row)
            NSUserDefaults.standardUserDefaults().setObject(RecentFriends, forKey: "RecentFriends")
            RecentTableView.reloadData()
        }
    }
    
    func callphone(sender:RecentTap){
        var callfriend:[String:String] = RecentFriends[sender.tag] as! [String : String]
        let num = NSString(string: callfriend["phone"]!)
        let phoneurl = NSURL(string: "tel:\(num)")
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        callfriend["time"] = "拨号" + timeFormatter.stringFromDate(NSDate())
        RecentFriends[sender.tag] = callfriend
        NSUserDefaults.standardUserDefaults().setObject(RecentFriends, forKey: "RecentFriends")
        RecentTableView.reloadData()
        UIApplication.sharedApplication().openURL(phoneurl!)
    }
    func sendmsg(sender:RecentTap){
        var msgfriend:[String:String] = RecentFriends[sender.tag] as! [String : String]
        let num = NSString(string: RecentFriends[sender.tag]["phone"] as! String)
        let phoneurl = NSURL(string: "sms:\(num)")
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        msgfriend["time"] = "短信" + timeFormatter.stringFromDate(NSDate())
        RecentFriends[sender.tag] = msgfriend
        NSUserDefaults.standardUserDefaults().setObject(RecentFriends, forKey: "RecentFriends")
        RecentTableView.reloadData()
        UIApplication.sharedApplication().openURL(phoneurl!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.title = "好友列表"
        self.navigationController?.navigationBarHidden = false
        // 检查SectionInfoArray是否已被创建，如果已被创建，则检查组的数量是否匹配当前实际组的数量。通常情况下，您需要保持SectionInfo与组、单元格信息保持同步。如果扩展功能以让用户能够在表视图中编辑信息，那么需要在编辑操作中适当更新SectionInfo
        if sectionInfoArray == nil || sectionInfoArray.count != self.numberOfSectionsInTableView(ContactTableView) {
            // 对于每个用户组来说，需要为每个单元格设立一个一致的SectionInfo对象
            let infoArray: NSMutableArray = NSMutableArray()
            for group in Contacts {
                let sectionInfo = SectionInfo()
                sectionInfo.group = group as! Group
                sectionInfo.headerView.HeaderOpen = false
                infoArray.addObject(sectionInfo)
            }
            sectionInfoArray = infoArray
        }
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        menuView.hide()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    

    
    func getContacts() -> NSArray {
        
        let action = "groups?data="
        let username = String(NSUserDefaults.standardUserDefaults().valueForKey("username")!)
        var url = "{\"username\":\"\(username)\"}"
        var datas = NSMutableArray()
        url = Config.ip + action + url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet())!
        let request = NSURLRequest(URL:NSURL(string:url)!,cachePolicy:NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData,timeoutInterval:10.0)
        let session = NSURLSession.sharedSession()
        let semaphore = dispatch_semaphore_create(0)
        let dataTask = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            if error != nil{
                let warning = UIAlertController(title: "提示", message: "获取好友列表出错", preferredStyle: .Alert)
                let ok = UIAlertAction(title: "好", style: .Default, handler: nil)
                warning.addAction(ok)
                self.presentViewController(warning, animated: true, completion: nil)
            }else{
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    let groupnamelist = json.objectForKey("groupNameList")!
                    datas = NSMutableArray(capacity: groupnamelist.count)
                    
                    for groupcount in 0..<groupnamelist.count{
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
                            let facepath = Config.ip + "faces/" + (friendlist[friendcount]!.objectForKey("username")! as! String) + ".jpg"
                            friend.setValuesForKeysWithDictionary(["usericon":facepath])
                            if let signature = friendlist[friendcount]!.objectForKey("signature"){
                                friend.setValuesForKeysWithDictionary(["signature":(signature as! String)])
                            }else{
                                friend.setValuesForKeysWithDictionary(["signature":"这家伙很懒，没有留下签名"])
                            }
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
    
    func changeTableView(showContact:Bool){
        ContactTableView.hidden = !showContact
        RecentTableView.hidden = showContact
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toAddFriend"{
            self.navigationController?.title = "添加好友"
        }
        if segue.identifier == "frienddetail"{
            if tochange{
                tochange = false
                self.navigationController?.title = "资料修改"
                let destcontroller = segue.destinationViewController as! PeopleInfoDetailView
                destcontroller.intend = UIBarButtonSystemItem.Done
            }else{
                
                let destcontroller = segue.destinationViewController as! PeopleInfoDetailView
                self.navigationController?.title = "好友详情"
                destcontroller.people = selectedfriend
                destcontroller.intend = UIBarButtonSystemItem.Trash
            }
        }
    }
    

}
