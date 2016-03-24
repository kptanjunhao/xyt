//
//  Message.swift
//  newpractice
//
//  Created by 钧豪 谭 on 16/1/3.
//  Copyright © 2016年 钧豪 谭. All rights reserved.
//

import Foundation
class Message: NSObject {
    var title:String = ""
    var noticeid:String = ""
    var time:String = ""
    var flag:String = ""
    var content:String = ""
    var noticegroup:String = ""
    var attrrec = ["title","noticeid","time","flag"]
    var attrreccn = ["title":"标题","time":"时间","flag":"状态"]
    var attrdsend = ["title","noticeid","time","noticegroup"]
    var attrsendcn = ["title":"标题","time":"时间"]
    //"title":"好友申请","noticeid":87,"time":"2015-12-29 16:12:39.0","flag":0
    //{"title":"困难","noticeid":59,"time":"2015-12-16 09:21:49.0","noticegroup":"505052904"}
}