//
//  FriendInfoCell.swift
//  newpractice
//
//  Created by 钧豪 谭 on 15/12/30.
//  Copyright © 2015年 钧豪 谭. All rights reserved.
//

import UIKit



class FriendInfoCell: UITableViewCell {
    @IBOutlet weak var attrLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    func setInfoCell(attr:String , value:String){
        self.attrLabel.text = attr
        self.valueLabel.text = value
    }
 

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
 

}
