//
//  TradeViewController.swift
//  newxyt
//
//  Created by 谭钧豪 on 16/3/25.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit
class TradeViewController: UITableViewController {
    var Goods = [Good]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let newgood0 = Good()
        newgood0.images = ["123","345","567","789"]
        newgood0.id = 0
        newgood0.descript = "没什么特别的爱买不买"
        let newgood1 = Good()
        newgood1.id = 1
        newgood1.images = ["1123","3345","5567","7789"]
        newgood1.descript = "也没什么特别的爱买不买"
        Goods.append(newgood0)
        Goods.append(newgood1)
        let additem = UIBarButtonItem(title: "添加", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TradeViewController.additem))
        let viewitem = UIBarButtonItem(title: "查看", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TradeViewController.viewitem))
        self.navigationItem.rightBarButtonItems = [viewitem,additem]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func validLogin() -> Bool{
        let loginstatu = NSUserDefaults.standardUserDefaults().valueForKey("iflogin") as! Bool
        if !loginstatu{
            let warning = UIAlertController(title: "提示", message: "请先登录", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "好", style: UIAlertActionStyle.Default, handler: { (OK) -> Void in
                warning.dismissViewControllerAnimated(true, completion: nil)
                self.tabBarController?.selectedIndex = 0
            })
            warning.addAction(okAction)
            presentViewController(warning, animated: true, completion: nil)
            return false
        }else{
            return true
        }
    }
    
    func additem(){
        if validLogin(){
            performSegueWithIdentifier("additem", sender: self)
        }
    }
    
    func viewitem(){
        if validLogin(){
            performSegueWithIdentifier("viewitem", sender: self)
        }
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
        return Goods.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 280
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setSelected(false, animated: false)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let curgood = Goods[indexPath.row]
        let cell = UITableViewCell()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let faceicon = UIImageView(frame: CGRectMake(5, 5, 40, 40))
        faceicon.backgroundColor = UIColor.blackColor()
        cell.addSubview(faceicon)
        let title = UILabel(frame: CGRectMake(50,5,150,20))
        title.text = "no"
        cell.addSubview(title)
        let time = UILabel(frame: CGRectMake(50,25,150,20))
        time.textColor = UIColor.lightGrayColor()
        time.text = "1970.01.01 00:00:01"
        time.font = UIFont.systemFontOfSize(12)
        cell.addSubview(time)
        let price = UILabel(frame: CGRectMake(cell.frame.width-100,10,150,30))
        price.textColor = UIColor.orangeColor()
        price.font = UIFont.boldSystemFontOfSize(30)
        price.text = "10000.00"
        price.textAlignment = NSTextAlignment.Right
        cell.addSubview(price)
        let scrollView = UIScrollView(frame: CGRectMake(0,50,self.tableView.frame.width,130))
        for count in 0..<curgood.images.count {
            //滚动图片设置
            let str = UILabel(frame: CGRectMake(5+CGFloat(count)*130,5,120,120))
            str.text = curgood.images[count]
            str.backgroundColor = UIColor.redColor()
            scrollView.addSubview(str)
        }
        scrollView.contentSize = CGSizeMake(125+CGFloat(curgood.images.count-1)*130, 130)
        cell.addSubview(scrollView)
        let descript = UILabel(frame: CGRectMake(5,180,self.tableView.frame.width,70))
        descript.lineBreakMode = NSLineBreakMode.ByWordWrapping
        descript.numberOfLines = 0
        descript.textColor = UIColor.grayColor()
        descript.text = "我是描述"
        cell.addSubview(descript)
        let fromwhere = UILabel(frame: CGRectMake(5,250,150,30))
        fromwhere.textColor = UIColor.lightGrayColor()
        fromwhere.font = UIFont.systemFontOfSize(12)
        fromwhere.text = "123123123班"
        cell.addSubview(fromwhere)
        let viewcount = UILabel(frame: CGRectMake(cell.frame.width-100,250,150,20))
        viewcount.textColor = UIColor.lightGrayColor()
        viewcount.font = UIFont.systemFontOfSize(12)
        viewcount.text = "10000"+"次"
        viewcount.textAlignment = NSTextAlignment.Right
        cell.addSubview(viewcount)
        
        

        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.title = "交易市场"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.title = "功能"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
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
