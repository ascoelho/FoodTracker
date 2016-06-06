//
//  LoginViewController.swift
//  FoodTracker
//
//  Created by Anthony Coelho on 2016-06-06.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self;
        passwordTextField.delegate = self;

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let username = userDefaults.objectForKey("username") as? String {
            print(username)
        }
        if let password = userDefaults.objectForKey("password") as? String {
            print(password)
        }
        if let token = userDefaults.objectForKey("token") as? String {
            print(token)
            
        }
        
       
        
    }
    
    
    
    @IBAction func signup(sender: UIButton) {
        
        if passwordTextField.text?.characters.count >= 8 && usernameTextField.text?.isEmpty == false {
            let postData = [
                "username": usernameTextField.text ?? "",
                "password": passwordTextField.text ?? ""
            ]
            
            guard let postJSON = try? NSJSONSerialization.dataWithJSONObject(postData, options: []) else {
                print("could not serialize json")
                return
            }
            
            let req = NSMutableURLRequest(URL: NSURL(string:"http://159.203.243.24:8000/signup")!)
            
            req.HTTPBody = postJSON
            req.HTTPMethod = "POST"
            req.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(req) { (data, resp, err) in
                
                guard let data = data else {
                    print("no data returned from server \(err)")
                    return
                }
                
                guard let resp = resp as? NSHTTPURLResponse else {
                    print("no response returned from server \(err)")
                    return
                }
                
                guard let rawJson = try? NSJSONSerialization.JSONObjectWithData(data, options: []) else {
                    print("data returned is not json, or not valid")
                    return
                }
                
                guard resp.statusCode == 200 else {
                    // handle error
                    print("an error occurred \(rawJson["error"])")
                    return
                }
                
                // do something with the data returned (decode json, save to user defaults, etc.)
                var json: NSDictionary!
                do {
                    json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? NSDictionary
                } catch {
                    print(error)
                }
                
                let user = json["user"] as! NSDictionary

                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setObject(user["username"], forKey: "username")
                userDefaults.setObject(user["password"], forKey: "password")
                userDefaults.setObject(user["token"], forKey: "token")
                userDefaults.synchronize()

      
            }
            
            task.resume()
            
            
        }
        else {
            print("username and/or password invalid")
        }
  
    }
    @IBAction func login(sender: UIButton) {
        if passwordTextField.text?.characters.count >= 8 && usernameTextField.text?.isEmpty == false {
            let postData = [
                "username": usernameTextField.text ?? "",
                "password": passwordTextField.text ?? ""
            ]
            
            guard let postJSON = try? NSJSONSerialization.dataWithJSONObject(postData, options: []) else {
                print("could not serialize json")
                return
            }
            
            let req = NSMutableURLRequest(URL: NSURL(string:"http://159.203.243.24:8000/login")!)
            
            req.HTTPBody = postJSON
            req.HTTPMethod = "Post"
            req.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(req) { (data, resp, err) in
                
                guard let data = data else {
                    print("no data returned from server \(err)")
                    return
                }
                
                guard let resp = resp as? NSHTTPURLResponse else {
                    print("no response returned from server \(err)")
                    return
                }
                
                guard let rawJson = try? NSJSONSerialization.JSONObjectWithData(data, options: []) else {
                    print("data returned is not json, or not valid")
                    return
                }
                
                guard resp.statusCode == 200 else {
                    // handle error
                    print("an error occurred \(rawJson["error"])")
                    return
                }
                
                // do something with the data returned (decode json, save to user defaults, etc.)
                var json: NSDictionary!
                do {
                    json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? NSDictionary
                } catch {
                    print(error)
                }
                
                let user = json["user"] as! NSDictionary
                
                if let username = user["username"] as? String {
                    
                    if username == self.usernameTextField.text {
                        print("Allowed to login")
                        dispatch_async(dispatch_get_main_queue(), {
                        self.performSegueWithIdentifier("showTVC", sender: sender)
                        })
                    }
                    
                }
                else {
                    print("user not found in database")
                }
       
            }
            
            task.resume()

        }
        else {
            print("username and/or password invalid")
        }


    }

    
}