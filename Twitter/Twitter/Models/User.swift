//
//  User.swift
//  Twitter
//
//  Created by Quoc Huy Ngo on 2/12/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit

struct KEYs {
    static let userInfo = "userInfo"
    static let accessToken = "accessToken"
}
var _currentUser:User?
class User: NSObject {
    var id:Int?
    var name:String?
    var screenName:String?
    var profileImage:String?
    var dictionary:NSDictionary?
    override init() {
    
    }
    
    init(data: NSDictionary) {
        dictionary = data
        id = data["id"] as? Int
        name = data["name"] as? String
        screenName = data["screen_name"] as? String
        profileImage = data["profile_image_url"] as? String
    }
    
    static var currentUser: User? {
        get {
            if _currentUser == nil {
                if let data = UserDefaults.standard.object(forKey: KEYs.userInfo){
    
                    let dictionary = try! JSONSerialization.jsonObject(with: data as! Data, options: []) as! NSDictionary
                    _currentUser = User(data: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            if _currentUser != nil {
                let data = try! JSONSerialization.data(withJSONObject: _currentUser?.dictionary! as Any, options: [])
                UserDefaults.standard.set(data, forKey: KEYs.userInfo)
            }
            else {
                UserDefaults.standard.set(nil, forKey: KEYs.userInfo)
            }
            UserDefaults.standard.synchronize()
        }
    }
    
}
