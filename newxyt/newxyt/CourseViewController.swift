//
//  CourseViewController.swift
//  newxyt
//
//  Created by 谭钧豪 on 16/2/6.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

class CourseViewController: UIViewController {
    var json:AnyObject? = ""
    class courses{
        var course = [String:String]()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screen = UIScreen.mainScreen().bounds
        let subViewW:CGFloat = UIScreen.mainScreen().bounds.width/11
        let subViewH:CGFloat = UIScreen.mainScreen().bounds.height/9
        var day = ["星期一","星期二","星期三","星期四","星期五","星期六","星期天",]
        var courseslist = [courses]()
        let courseclass = ["第一节","第二节","第三节","第四节","第五节","第六节","第七节","第八节","第九节","第十节"]
        let bstatus = String(json!.objectForKey("status")!)
        
        let marginX:CGFloat = 10
        let marginY:CGFloat = 10
        if bstatus=="success"{
            let name = String(json!.objectForKey("name")!)
            let namelabel = UILabel()
            namelabel.text = name
            namelabel.font = UIFont.systemFontOfSize(CGFloat(20))
            namelabel.frame = CGRect(x: screen.width/2-10, y: 10, width: 20, height: 25)
            let datas = json!.objectForKey("datas") as? NSArray
            
            for day in 0..<datas!.count{
                let courseobject = datas![day]
                let coursevar = courses()
                for num in courseclass{
                    coursevar.course.updateValue(String(courseobject.objectForKey(num)!), forKey: num)
                }
                courseslist.append(coursevar)
            }
            
        }else{}
        
        
        
        for d in 0..<day.count{
            let labelc = UILabel()
            
            labelc.text = day[d]
            labelc.font = UIFont.systemFontOfSize(CGFloat(11))
            labelc.lineBreakMode = NSLineBreakMode.ByWordWrapping
            labelc.numberOfLines = 0;
            labelc.frame = CGRect(x: screen.width/7 + CGFloat(d) * (marginX + subViewW), y: screen.height/12, width: subViewW, height: subViewH)
            self.view.addSubview(labelc)
            
        }
        
        for c in 0..<courseclass.count/2{
            let labelr = UILabel()
            labelr.text = courseclass[c*2] + "\n\n" + courseclass[c*2+1] + "\n_______"
            labelr.lineBreakMode = NSLineBreakMode.ByWordWrapping
            labelr.numberOfLines = 0;
            labelr.font = UIFont.systemFontOfSize(CGFloat(12))
            labelr.frame = CGRect(x: 5, y: screen.height/6 + CGFloat(c) * (marginY + subViewH), width: subViewW*2, height: subViewH)
            self.view.addSubview(labelr)
            
        }
        
        for i in 0..<70{
            //            let subView = UIView()
            let row = i / 7
            let column = i % 7
            
            let subViewX = screen.width/7 + CGFloat(column) * (marginX + subViewW)
            let subViewY = screen.height/6 + CGFloat(row) * (marginY + subViewH)/2
            
            let classlabel = UILabel()
            classlabel.text = courseslist[i%7].course[courseclass[i/7]]
            classlabel.font = UIFont.systemFontOfSize(CGFloat(8))
            classlabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            classlabel.numberOfLines = 0;
            classlabel.frame = CGRect(x: subViewX, y: subViewY, width: subViewW, height: subViewH/2)
            self.view.addSubview(classlabel)
            
            //            subView.frame = CGRect(x: subViewX, y: subViewY, width: subViewW, height: subViewH)
            
            //            subView.backgroundColor = UIColor.blueColor()
            //            self.view.addSubview(subView)
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}