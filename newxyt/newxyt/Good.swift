//
//  GoodsDetail.swift
//  newxyt
//
//  Created by 谭钧豪 on 16/3/28.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import Foundation

class Good: NSObject {
    var id:Int = 0
    var face:String = ""
    var userid:String = ""
    var username:String = ""
    var fromWhere:String = ""
    var descript:String = ""
    var viewCount:Int = 0
    var date:Int = 0
    var closeFlag:Int = 0
    var price:Double = 0
    var images:[String] = [String]()
    
}