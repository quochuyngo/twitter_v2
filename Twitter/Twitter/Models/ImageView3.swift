//
//  ImageView3.swift
//  Twitter
//
//  Created by Quoc Huy Ngo on 2/15/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class ImageView3 : UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView1: UIImageView!
    override func awakeFromNib() {
        contentView.layer.cornerRadius = 4
        contentView.clipsToBounds = true
    }
}
