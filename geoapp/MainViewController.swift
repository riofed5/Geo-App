//
//  MainViewController.swift
//  geoapp
//
//  Created by Quan Dao on 27.4.2020.
//  Copyright © 2020 team geo app. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    @IBOutlet weak var mainFreeModeBtn: UIButton!
    @IBOutlet weak var mainSignInBtn: UIButton!
    @IBOutlet weak var mainRegisterBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style the buttons
        mainFreeModeBtn.layer.cornerRadius = 8
        mainSignInBtn.layer.cornerRadius = 8
        mainRegisterBtn.layer.cornerRadius = 8
        
        mainFreeModeBtn.backgroundColor = UIColor(red: 0.90, green: 0.22, blue: 0.27, alpha: 1.00)
        mainSignInBtn.backgroundColor = UIColor(red: 0.27, green: 0.48, blue: 0.62, alpha: 1.00)
        mainRegisterBtn.backgroundColor = UIColor(red: 0.11, green: 0.21, blue: 0.34, alpha: 1.00)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userInfos:NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
        if let users = try? AppDelegate.viewContext.fetch(userInfos) {
            if (users.count != 0) {
                Helpers.showHomeView(self)
                return
            }
        }
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
