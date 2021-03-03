//
//  TestViewController.swift
//  geoapp
//
//  Created by Quan Dao on 19.4.2020.
//  Copyright © 2020 team geo app. All rights reserved.
//

import UIKit
import Firebase

class TestViewController: UIViewController {
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        
        ref.child("users").child("test").setValue(["score": 10])
        
        _ = ref.observe(DataEventType.value, with: { (snapshot) in
          let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            let users = postDict["users"] as! NSDictionary
            let test = users["test"] as! NSDictionary
            print(test["score"] as! NSNumber)
          // ...
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
