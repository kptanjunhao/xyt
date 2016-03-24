//
//  Friend.swift
//  newpractice
//
//  Created by 钧豪 谭 on 15/12/29.
//  Copyright © 2015年 钧豪 谭. All rights reserved.
//

import Foundation
class Friend: NSObject {
    var userid: String = ""
    var realname: String = ""
    var signature: String = ""
    var nickname: String = ""
    var useryear: String = ""
    var score: String = ""
    var phone: String = ""
    var gender: String = ""
    var qq: String = ""
    var weixin: String = ""
    var isregister: String = ""
    var classid: String = ""
    var classname: String = ""
    var year: String = ""
    var departmentid: String = ""
    var departmentname: String = ""
    var usericon:String = ""
    var selected:Bool = false
    var allattr = ["userid","classname","departmentname","isregister","usergender","usernickname","userphone","userqq","userrealname","usersignature","userweixin","useryear"]
    var allowchangeattr = ["usersignature","userrealname","userphone","userqq","userweixin","usergender"]
    var updatekey = ["signature","realname","phone","qq","weixin","gender"]
    var attrname = ["userid":"帐号","classname":"所在班级","departmentname":"所属系","isregister":"注册状态","usergender":"性别","usernickname":"昵称","userphone":"电话","userqq":"QQ","userrealname":"姓名","usersignature":"签名","userweixin":"微信","useryear":"入学年份"]


}
