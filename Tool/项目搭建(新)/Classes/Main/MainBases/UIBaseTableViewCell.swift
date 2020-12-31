//
//  UIBaseTableViewCell.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/30.
//

import UIKit

class UIBaseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK: - Action
extension UIBaseTableViewCell {
    
    /**
     返回当前类型的String
     */
    class func toString() -> String {
        return NSStringFromClass(self)
    }
}
