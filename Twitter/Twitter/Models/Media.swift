//
//  Media.swift
//  Twitter
//
//  Created by Quoc Huy Ngo on 2/18/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class Media {
    var mediaUrls:[String] = [String]()
    var url:String = ""
    
    init() {
        
    }
    
    init(data: NSDictionary) {
        if let mediaArray = data["media"] {
            for mediaUrl in mediaArray as! [NSDictionary] {
                mediaUrls.append(mediaUrl["media_url"] as! String + ":thumb")
                url = (mediaUrl["url"] as? String)!
            }
        }
        else if let mediaUrl = data["media"] {
            mediaUrls.append((mediaUrl as! NSDictionary)["media_url"] as! String + ":small")
            url = ((mediaUrl as! NSDictionary)["url"] as? String)!
        }
    }
}
