//
//  AddFriendViewController.swift
//  newpractice
//
//  Created by 钧豪 谭 on 15/12/31.
//  Copyright © 2015年 钧豪 谭. All rights reserved.
//

import UIKit
import QuartzCore

class AddFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var inputstatu = "no"
    let screen = UIScreen.mainScreen().bounds
    let userid = String(NSUserDefaults.standardUserDefaults().valueForKey("username")!)
    let action = "fuzzyFind?data="
    var searchresult = [Int:AnyObject]()
    var friends: NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var searchTableView: UITableView!
    
    var nameTF:UITextField!
    var addBtn:UIButton!
    
    func loaddata(){
        self.searchresult.removeAll()
        var url = "{\"username\":\"\(nameTF.text!)\",\"userid\":\"\(userid)\"}"
        url = Config.ip + action + url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let request = NSURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 2.0)
        let session = NSURLSession.sharedSession()
        let semaphore = dispatch_semaphore_create(0)
        let dataTask = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            if error != nil {
                print(error)
            }else{
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    if !json.isEqual(0){
                        self.searchTableView.userInteractionEnabled = true
                        let datas = json.objectForKey("datas")!
                        for datacount in 0..<datas.count{
                            let friend:Friend = Friend()
                            self.searchresult[datacount] = datas[datacount]!.objectForKey("userrealname")
                            friend.setValuesForKeysWithDictionary(["realname":datas[datacount]!.objectForKey("userrealname")!])
                            friend.setValuesForKeysWithDictionary(["userid":datas[datacount]!.objectForKey("userid")!])
                            self.friends.addObject(friend)
                        }
                    }else{
                        self.searchresult.removeAll()
                        self.searchresult[0] = "已经是好友啦，或者没有这个人呢"
                        self.searchTableView.userInteractionEnabled = false
                    }
                    
                }catch{
                    print("捕获到一个错误",data!)
                }
                dispatch_semaphore_signal(semaphore)
            }
        }) as NSURLSessionTask
        dataTask.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        searchTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchresult.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("nameCell", forIndexPath: indexPath)
        cell.textLabel?.text = searchresult[indexPath.row]! as? String
        cell.separatorInset = UIEdgeInsetsZero
        return cell
    }
    
    
    func search(){
        loaddata()
        UIView.animateWithDuration(0.5, animations: {
            ()->Void in
            self.nameTF.frame = CGRectMake(self.nameTF.frame.origin.x, 16, self.nameTF.frame.width, self.nameTF.frame.height)
            self.addBtn.frame = CGRectMake(self.addBtn.frame.origin.x, 16, self.addBtn.frame.width, self.addBtn.frame.height)
            }, completion: {
                (Bool)->Void in
                self.inputstatu = "yes"
                self.searchTableView.hidden = false
        })
        
    }
    
    //文本框判断
    func nameTFvaluechange() {
        if nameTF.text == ""{
            addBtn.enabled = false
            addBtn.backgroundColor = UIColor.grayColor()
            self.searchresult.removeAll()
            self.searchTableView.reloadData()
        }else{
            if inputstatu == "yes"{
                loaddata()
            }
            addBtn.enabled = true
            addBtn.backgroundColor = UIColor(red: 0.0, green: 128.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
        
        
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if nameTF.text != ""{
            if inputstatu != "yes"{
            search()
            }
        }else{
           nameTFisEmpty()
        }
        return true
    }
    
    func nameTFisEmpty(){
        let warning = UIAlertController(title: "提示", message: "请先输入一个好友名字", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "好", style: .Default, handler: nil)
        warning.addAction(OKAction)
        presentViewController(warning, animated: true, completion: nil)
    }
    
    
    override func animationDidStart(anim: CAAnimation) {
        super.animationDidStart(anim)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "添加好友"
        searchTableView.delegate = self
        searchTableView.dataSource = self
        let screen = UIScreen.mainScreen().bounds
        let y = screen.height - 176
        nameTF = UITextField(frame: CGRectMake(26, y/2, screen.width-117, 30))
        nameTF.delegate = self
        nameTF.placeholder = "请输入好友的姓名"
        nameTF.addTarget(self, action: #selector(AddFriendViewController.nameTFvaluechange), forControlEvents: .EditingChanged)
        nameTF.borderStyle = .RoundedRect
        nameTF.clearButtonMode = .Always
        nameTF.autocorrectionType = .No
        nameTF.autocapitalizationType = .None
        
        addBtn = UIButton(frame: CGRectMake(screen.width - 81, y/2, 55, 30))
        addBtn.setTitle("查询", forState: .Normal)
        addBtn.backgroundColor = UIColor.grayColor()
        addBtn.addTarget(self, action: #selector(AddFriendViewController.search), forControlEvents: .TouchUpInside)
        addBtn.layer.cornerRadius = 8
        addBtn.enabled = false

        self.view.addSubview(addBtn)
        self.view.addSubview(nameTF)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Add"{
            if let selectedGroupCell = sender as? UITableViewCell {
                let indexPath = searchTableView.indexPathForCell(selectedGroupCell)!
                let destcontroller = segue.destinationViewController as! PeopleInfoDetailView
                destcontroller.people.userid = friends[indexPath.row].userid
                print(friends[indexPath.row].userid)
                destcontroller.intend = UIBarButtonSystemItem.Add
                
            }
        }
    }

}
