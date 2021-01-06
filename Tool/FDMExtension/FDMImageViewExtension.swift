//
//  FDMImageViewExtension.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2021/1/4.
//

import UIKit
import Kingfisher

//MARK: - Kingfisher
extension UIImageView {
    func setImageWithUrl(_ url: String, placeholder: UIImage?) {
        self.kf.setImage(with: URL(string: url), placeholder: placeholder)
    }
}
