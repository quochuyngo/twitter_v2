//
//  TwitterClient.swift
//  Twitter
//
//  Created by Quoc Huy Ngo on 2/8/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import AFNetworking
import BDBOAuth1Manager

let API_KEY = "8pheut7KeZ4uUk9f4Rgij0BhI"//"xP5ncED0NhvByFYxQu0seLUwf"
let API_SECRET = "7Fly9qwg3XbjR80wmnwyFrS7wbVw6yGGSWjPFmdiWfKIkOCeAK"//"oA2xSASBMBtf4jS6PzKt1Vcgvb7RIZ7Y3isyV8usIlrqt4M7Zp"
struct URLs {
    static let baseURL = "https://api.twitter.com"
    static let requestToken = "oauth/request_token"
    static let accessToken =   "oauth/access_token"
    static let callbackURL = "twitterreview://oauth"
    static let authURL = URLs.baseURL + "/oauth/authorize?oauth_token="
    static let verifyCredentials = "1.1/account/verify_credentials.json"
    static let homeTimeline = "1.1/statuses/home_timeline.json"
    static let createFavorite = "1.1/favorites/create.json"
    static let destroyFavorite = "1.1/favorites/destroy.json"
    static let retweet = "1.1/statuses/retweet/"
    static let unretweet = "1.1/statuses/unretweet/"
    static let updateTweet = "1.1/statuses/update.json"
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

    func getTweets (max_id:Int?, success: @escaping ([Tweet]) -> Void, failure: ((Error) -> Void)? = nil) {
        var parameters = [String:AnyObject]()
        if max_id != nil {
            parameters["max_id"] = (max_id! - 1) as AnyObject?
        }
        
        get(URLs.homeTimeline, parameters: parameters, progress: nil, success: {(task, response) in
            print(response!)
            let dataArray = response as! [NSDictionary]
            var tweets:[Tweet] = [Tweet]()
            for data in dataArray {
                let tweet = Tweet(data: data)
                tweets.append(tweet)
            }
            success(tweets)
        }, failure: {(task, error) in
            failure?(error)
        })
    }
    
    func likeTweet(id:Int!, success: @escaping (Tweet) -> Void, failure: ((Error) -> Void)? = nil) {
        var parameters = [String:AnyObject]()
        parameters["id"] = id as AnyObject?
        
        post(URLs.createFavorite, parameters: parameters, progress: nil, success: {(task, response) in
            if let data = response {
                let tweet = Tweet(data: data as! NSDictionary)
                success(tweet)
            }
          
        }, failure:{(task, error) in
            failure?(error)
        })
    }
    
    func unlikeTweet(id:Int!,  success: @escaping (Tweet) -> Void, failure: ((Error) -> Void)? = nil) {
        var parameters = [String:AnyObject]()
        parameters["id"] = id as AnyObject?
        
        post(URLs.destroyFavorite, parameters: parameters, progress: nil, success: {(task, response) in
            if let data = response {
                let tweet = Tweet(data: data as! NSDictionary)
                success(tweet)
            }
            
        }, failure:{(task, error) in
            failure?(error)
        })
    }
    
    func retweet(id:Int!,  success: @escaping (Tweet) -> Void, failure: ((Error) -> Void)? = nil) {
        post(URLs.retweet + "\(id!).json", parameters: nil, progress: nil, success: {(task, response) in
            if let data = response {
                let tweet = Tweet(data: data as! NSDictionary)
                success(tweet)
            }
        }, failure:{(task, error) in
            print(error)
        })
    }
    
    func unretweet(id:Int!,  success: @escaping (Tweet) -> Void, failure: ((Error) -> Void)? = nil) {
        post(URLs.unretweet + "\(id!).json", parameters: nil, progress: nil, success: {(task, response) in
            if let data = response {
                let tweet = Tweet(data: data as! NSDictionary)
                success(tweet)
            }
        }, failure:{(task, error) in
            print(error)
        })
    }
    
    func tweet(status:String!, success: @escaping (Tweet) -> Void, failure: ((Error) -> Void)? = nil) {
        var parameters = [String:AnyObject]()
        parameters["status"] = status as AnyObject?
        
        post(URLs.updateTweet, parameters: parameters, progress: nil, success: {(task, response) in
            let tweet = Tweet(data: response as! NSDictionary)
            success(tweet)
        }, failure: {(task, error) in
            print(error)
        })
    }
}
