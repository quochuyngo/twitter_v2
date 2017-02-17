//
//  TwitterClient.swift
//  Twitter
//
//  Created by Quoc Huy Ngo on 2/8/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import AFNetworking
import BDBOAuth1Manager

let API_KEY = "xP5ncED0NhvByFYxQu0seLUwf"//"CSlvbipf1svqF2KTKx2f9hQ3W"
let API_SECRET = "oA2xSASBMBtf4jS6PzKt1Vcgvb7RIZ7Y3isyV8usIlrqt4M7Zp"//"nobu0OxMQyLTuHt9jNkmJBPHnuMmZJotCRkpdGqHennLVO4lgG"

struct URLs {
    static let baseURL = "https://api.twitter.com"
    static let requestToken = "oauth/request_token"
    static let accessToken =   "oauth/access_token"
    static let callbackURL = "twitterreview://oauth"
    static let authURL = URLs.baseURL + "/oauth/authorize?oauth_token="
    static let verifyCredentials = "1.1/account/verify_credentials.json"
    static let homeTimeline = "1.1/statuses/home_timeline.json"
}

class TwitterClient: BDBOAuth1SessionManager {
    class var shareInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(
                baseURL: URL(string: URLs.baseURL),
                consumerKey: API_KEY,
                consumerSecret: API_SECRET)
            
        }
        return Static.instance!
    }
    
    //var loginCompletion: ((_ user: User?, _ error: Error?) -> ())?
    var loginSuccess: (() -> Void )?
    var loginFailure: ((Error) -> Void)?
    
    func login(success: @escaping (() -> Void), failure: @escaping ((Error) -> Void)) {
        loginSuccess =  success
        loginFailure = failure
        deauthorize()
        
        fetchRequestToken(withPath: URLs.requestToken, method: "POST", callbackURL: URL(string:URLs.callbackURL), scope: nil, success: {(response) in
            if let requestToken = response {
                let authURL = URL(string: URLs.authURL + (requestToken.token)!)
                UIApplication.shared.open(authURL!, options: [:])
            }
        }, failure: { (error) in
            failure(error!)
        })
    }
    
    func handleCallbackURL(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: URLs.accessToken, method: "POST", requestToken: requestToken, success: {( response) in
    
            self.requestSerializer.saveAccessToken(response)
            AccessToken.currentToken = response
            self.loginSuccess?()
            
        }) {(error) in
            self.loginFailure?(error!)
        }
    }
    
    func getUserInfo(success: @escaping (User) -> Void) {
        get(URLs.verifyCredentials, parameters: nil, progress: nil, success: {(task, response) in
            let user = User(data: response as! NSDictionary)
            success(user)
        }, failure: {(task, error) in
            self.loginFailure!(error)
        })
    }
    //
    func getTweets (success: @escaping([Tweet]) -> Void) {
        get(URLs.homeTimeline, parameters: nil, progress: nil, success: {(task, response) in
            print(response!)
            let dataArray = response as! [NSDictionary]
            var tweets:[Tweet] = [Tweet]()
            for data in dataArray {
                let tweet = Tweet(data: data)
                tweets.append(tweet)
            }
            success(tweets)
        }, failure: {(task, error) in
            print(error)
        })
    }
}
