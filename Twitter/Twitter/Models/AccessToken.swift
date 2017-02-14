//
//  AccessToken.swift
//  Twitter
//
//  Created by Quoc Huy Ngo on 2/14/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import BDBOAuth1Manager

var _currentToken:BDBOAuth1Credential?
class AccessToken{
    static let shareInstance = AccessToken()
    
    static var currentToken: BDBOAuth1Credential? {
        get {
            if _currentToken == nil {
                if let data = UserDefaults.standard.object(forKey: KEYs.accessToken) {
                    _currentToken = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? BDBOAuth1Credential
                    //return _currentToken
                }
            }
            return _currentToken
        }
        
        set(token) {
            _currentToken = token
            if _currentToken  != nil {
                let data = NSKeyedArchiver.archivedData(withRootObject: _currentToken!)
                UserDefaults.standard.set(data, forKey: KEYs.accessToken)
            }
        }

    }
}
