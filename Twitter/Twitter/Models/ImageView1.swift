//
//  ImageView1.swift
//  Twitter
//
//  Created by Quoc Huy Ngo on 2/15/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class ImageView1: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        contentView.layer.cornerRadius = 4
        contentView.clipsToBounds = true
    }
}
