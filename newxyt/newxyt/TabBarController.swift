//
//  TabBarController.swift
//  newxyt
//
//  Created by 谭钧豪 on 16/2/2.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.tintColor = UIColor.blackColor()
        // Do any additional setup after loading the view.
    }
    
    
    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let TO:TransitioningObject = TransitioningObject()
        TO.tabBarController = self
        return TO
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

class TransitioningObject: NSObject, UIViewControllerAnimatedTransitioning {
    private weak var tabBarController:TabBarController!
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromView: UIView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let fromViewController: UIViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toView: UIView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let toViewController: UIViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        
        transitionContext.containerView()?.addSubview(fromView)
        transitionContext.containerView()?.addSubview(toView)
        
        _ = (self.tabBarController.viewControllers! as [UIViewController]).indexOf(fromViewController)
        let toViewControllerIndex = (self.tabBarController.viewControllers! as [UIViewController]).indexOf(toViewController)
        
        // 计算出点击的tab的位置，作为动画的圆心
        let tabBarFrame = tabBarController.tabBar.frame
        let tabBarItemCount = tabBarController.tabBar.items!.count
        let tabBarItemWidth = tabBarFrame.size.width / CGFloat(tabBarItemCount)
        
        let tappedItemY = tabBarFrame.origin.y
        let tappedItemX = tabBarItemWidth * CGFloat(toViewControllerIndex!) + tabBarItemWidth / 2
        
        // 圆要放大到的半径，勾股定理算出toView的对角线长度
        let finalRadius = sqrt(pow(toView.frame.height, 2) + pow(toView.frame.width, 2))
        
        // 构造开始时和结束时的圆的贝赛尔曲线。
        let start = UIBezierPath(ovalInRect: CGRect(x: tappedItemX, y: tappedItemY, width: 0, height: 0)).CGPath
        let final = UIBezierPath(ovalInRect: CGRect(x: tappedItemX - finalRadius, y: tappedItemY - finalRadius, width: finalRadius * 2, height: finalRadius * 2)).CGPath
        
        // 新建一个CAShapeLayer，用作toView的遮罩。并且开始时的path设置为上面的start——位置在点击的tab上的一个半径为0的圆。
        // 下文中就要给这个path加特技，让他变化到包含整个界面那么大。
        let circleMask = CAShapeLayer()
        circleMask.path = start
        toView.layer.mask = circleMask
        
        // 给circleMask的path属性加动画
        let animation = CABasicAnimation(keyPath:"path")
        animation.fromValue = start
        animation.toValue = final
        animation.duration = self.transitionDuration(transitionContext)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.delegate = self // 设置CABasicAnimation的delegate为self，好在动画结束后通知系统过渡完成了。
        animation.setValue(transitionContext, forKey:"transitionContext") // 待会需要用到transitionContext的completeTransition方法
        circleMask.addAnimation(animation, forKey:"circleAnimation")
        circleMask.path = final
    }
    
    // 过渡动画完成后，调用completeTransition说明过渡完成。
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if let context = anim.valueForKey("transitionContext") as? UIViewControllerContextTransitioning {
            context.completeTransition(true)
        }
    }
    
    // 持续时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
        
        
    }
}
