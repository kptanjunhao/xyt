//
//  MsgsCell.swift
//  newpractice
//
//  Created by 钧豪 谭 on 16/1/3.
//  Copyright © 2016年 钧豪 谭. All rights reserved.
//

import UIKit

class MsgsCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statuLabel: UILabel!

    var msg: Message!
    
    
    
    // 设置
    func setmsg(newmsg: Message) {
        msg = newmsg
        msg.time = (msg.time as NSString).substringToIndex(19) as String
        self.timeLabel.text = msg.time
        self.titleLabel.text = msg.title
        var statu = ""
        if msg.flag == "0"{
            statu = "未回复"
        }else if msg.flag == "1"{
            statu = "已回复"
        }
        self.statuLabel.text = statu
    }
    
}