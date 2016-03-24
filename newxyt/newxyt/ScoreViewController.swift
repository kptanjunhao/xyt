//
//  ScoreViewController.swift
//  newxyt
//
//  Created by 谭钧豪 on 16/2/12.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit


class ScoreViewController: UITableViewController {
    var datas = NSArray()
    var credit = ""
    var gpa = ""
    var name = ""
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datas.count+1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row != 0{
            return 25
        }else{
            return 40
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.row == 0{
            let namelabel = UILabel(frame: CGRectMake(10,10,120,30))
            namelabel.text = "\(name)"
            let creditlabel = UILabel(frame: CGRectMake(120,10,120,30))
            creditlabel.text = "总学分:\(credit)"
            let gpalabel = UILabel(frame: CGRectMake(240,10,130,30))
            gpalabel.text = "平均绩点:\(gpa)"
            cell.contentView.addSubview(namelabel)
            cell.contentView.addSubview(creditlabel)
            cell.contentView.addSubview(gpalabel)
        }else{
            let attrlabel = UILabel(frame: CGRectMake(10,0,150,30))
            attrlabel.text = datas[indexPath.row-1]["课程名称"] as? String
            attrlabel.font = UIFont.systemFontOfSize(15)
            let valuelabel = UILabel(frame: CGRectMake(160,0,200,30))
            var result:Int? = 0
            if let result1 = Int(datas[indexPath.row-1]["成绩"] as! String){
                result = result1
            }
            if let temp0 = Int(datas[indexPath.row-1]["重修成绩"] as! String){
                let mkresult:Int? = temp0
                if let temp1 = Int(datas[indexPath.row-1]["补考成绩"] as! String){
                    let reresult:Int? = temp1
                    if reresult > mkresult{
                        result = reresult!
                    }else if mkresult > result{
                        result = mkresult!
                    }
                }
            }else{
                if let temp1 = Int(datas[indexPath.row-1]["补考成绩"] as! String){
                    let reresult:Int? = temp1
                    result = reresult!
                }
            }
            if result < 60{
                valuelabel.text = ":  \(result!) (至今未通过)"
                valuelabel.textColor = UIColor.redColor()
                attrlabel.textColor = UIColor.redColor()
            }else{
                valuelabel.text = ":  \(result!)"
            }
            cell.contentView.addSubview(attrlabel)
            cell.contentView.addSubview(valuelabel)
        }
        return cell
    }

}
