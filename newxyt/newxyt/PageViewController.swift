//
//  PageViewController.swift
//  newxyt
//
//  Created by 谭钧豪 on 16/2/1.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var pageHeadings = ["","校园通","校园通可以查课表查绩点","查CET查天气","失物招领收发通知",""]
    var pageImages = ["","page1.png","page2.png","page3.png","page4.png",""]
    var pageSubHeadings = ["","向左滑动直接进入主界面",".",".","向右滑动进入主界面",""]
    var statubarhidden = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the data source to itself
        dataSource = self
        // Create the first walkthrough screen
        if let startingViewController = self.viewControllerAtIndex(1) {
            setViewControllers([startingViewController], direction: .Forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentViewController).index
        
        index+=1
        if index >= self.pageHeadings.count{
            statubarhidden = false
            self.dismissViewControllerAnimated(true, completion: nil)
            self.performSegueWithIdentifier("StartMain", sender: self)
            NSUserDefaults.standardUserDefaults().setValue(false, forKey: "FirstOpen")
            return self.viewControllerAtIndex(0)
        }
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentViewController).index
        
        index-=1
        if index < 0{
            statubarhidden = false
            self.dismissViewControllerAnimated(true, completion: nil)
            self.performSegueWithIdentifier("StartMain", sender: self)
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "FirstOpen")
            return self.viewControllerAtIndex(0)
        }
        return self.viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> PageContentViewController? {
        
        if index == NSNotFound || index < 0 || index >= self.pageHeadings.count {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        if let pageContentViewController = storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as? PageContentViewController {
            
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.subHeading = pageSubHeadings[index]
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        
        return nil
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return statubarhidden
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
