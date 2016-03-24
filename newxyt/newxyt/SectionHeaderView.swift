//
//  SectionHeaderView.swift
//  newxyt
//
//  Created by 谭钧豪 on 16/2/5.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

// 该协议将被用户组的委托实现； 当用户组被打开/关闭时，它将通知发送给委托，来告知Xcode调用何方法
protocol SectionHeaderViewDelegate: NSObjectProtocol {
    func sectionHeaderView(sectionHeaderView: SectionHeaderView, sectionOpened: Int)
    func sectionHeaderView(sectionHeaderView: SectionHeaderView, sectionClosed: Int)
}
class SectionHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var LblTitle: UILabel!
    @IBOutlet weak var BtnDisclosure: UIButton!
    var delegate: SectionHeaderViewDelegate!
    var section: Int!
    var HeaderOpen: Bool = false  // 标记HeaderView是否展开
    override func awakeFromNib() {
        // 设置disclosure 按钮的图片（被打开）
        self.BtnDisclosure.setImage(UIImage(named: "carat-open"), forState: UIControlState.Selected)
        // 单击手势识别
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SectionHeaderView.btnTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    @IBAction func btnTap(sender: AnyObject) {
        self.toggleOpen(true)
    }
    func toggleOpen(userAction: Bool) {
        BtnDisclosure.selected = !BtnDisclosure.selected
        // 如果userAction传入的值为真，将给委托传递相应的消息
        if userAction {
            if HeaderOpen {
                delegate.sectionHeaderView(self, sectionClosed: section)
            }
            else {
                delegate.sectionHeaderView(self, sectionOpened: section)
            }
        }
    }
}
