//
//  ViewController.swift
//  newxyt
//
//  Created by 谭钧豪 on 16/2/1.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {
    var headingLabel:UILabel!
    var subHeadingLabel:UILabel!
    var contentImageView:UIImageView!
    var index : Int = 0
    var heading : String = ""
    var imageFile : String = ""
    var subHeading : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headingLabel = UILabel(frame: CGRectMake(0,80,self.view.frame.width,30))
        headingLabel.text = "校园通"
        headingLabel.textAlignment = .Center
        headingLabel.font = UIFont.systemFontOfSize(34)
        subHeadingLabel = UILabel(frame: CGRectMake(0,self.view.frame.height - 70,self.view.frame.width,30))
        subHeadingLabel.text = "  Copyright © 2016年 谭钧豪. All rights reserved."
        subHeadingLabel.textAlignment = .Center
        subHeadingLabel.font = UIFont.systemFontOfSize(17)
        subHeadingLabel.textColor = UIColor.lightGrayColor()
        contentImageView = UIImageView(frame: self.view.frame)
        self.view.addSubview(contentImageView)
        self.view.addSubview(headingLabel)
        self.view.addSubview(subHeadingLabel)
        let pageInd = UIPageControl()
        if index % 2 != 0 {
            self.headingLabel.textColor = UIColor.blackColor()
        }else{
            self.headingLabel.textColor = UIColor.whiteColor()
        }
        pageInd.center.x = self.view.center.x
        pageInd.center.y = self.view.frame.height - 25
        pageInd.numberOfPages = 4
        pageInd.currentPage = index-1
        pageInd.pageIndicatorTintColor = UIColor.grayColor()
        pageInd.currentPageIndicatorTintColor = UIColor.whiteColor()
        self.view.addSubview(pageInd)
        if heading == "" {
            self.view.backgroundColor = UIColor.grayColor()
            headingLabel.text = "正在跳转"
            subHeadingLabel.text = "如果你看清了这行字，请再向左滑一下"
        }else{
            headingLabel.text = heading
            subHeadingLabel.text = subHeading
            let path = NSBundle.mainBundle().resourcePath!
            contentImageView.image = UIImage(contentsOfFile: path+"/"+imageFile)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

