//
//  HomeVC.swift
//  geoapp
//
//  Created by Nhan Nguyen on 22.4.2020.
//  Copyright © 2020 team geo app. All rights reserved.
//

import UIKit
import CoreData

class HomeVC: UIViewController {
    
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var selectMapBtn: UIButton!
    @IBOutlet weak var scoreBoardBtn: UIButton!
    
    @IBOutlet weak var challengeModeBtn: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currentUserScoreLabel: UILabel!
    @IBOutlet weak var challengeScoreLabel: UILabel!
    
    var challengePoint : NSNumber = 0
    var normalPoint : NSNumber = 0
    var curentUsername = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        Helpers.questionNumber = 0
        Helpers.cha_score = 0
        Helpers.nor_score = 0
        let userInfos:NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
        if let users = try? AppDelegate.viewContext.fetch(userInfos) {
            for user in users {
                nameLabel.text = user.username?.capitalized
                curentUsername = user.username ?? ""
            }
        }
        
        // Retrieve data from Firebase
        Helpers.databaseRef.child("scores").observe(.value, with: { (snapshot) in
            let score = snapshot.value as! NSDictionary
            for (key, value) in score {
                let currentKey = key as! String
                let currentNormalValue = (value as! NSDictionary)[Helpers.normalMode] ?? self.normalPoint
                let currentChallengeValue = (value as! NSDictionary)[Helpers.challengeMode] ?? self.challengePoint
                if (currentKey == self.curentUsername){
                    let normalString = NSLocalizedString("Normal: %d points", comment: "")
                    let chaString = NSLocalizedString("Challenge: %d points", comment: "")
                    self.currentUserScoreLabel.text = String.localizedStringWithFormat(normalString, currentNormalValue as! Int)
                    self.challengeScoreLabel.text = String.localizedStringWithFormat(chaString, currentChallengeValue as! Int)
                    Helpers.curcha_score = currentChallengeValue as! Int
                    Helpers.cur_score = currentNormalValue as! Int
                }
            }
        })
        
        // style the home page
        logOutBtn.layer.cornerRadius = 8
        logOutBtn.backgroundColor = UIColor(red: 0.97, green: 0.50, blue: 0.00, alpha: 1.00)
        
        scoreBoardBtn.layer.cornerRadius = 8
        scoreBoardBtn.backgroundColor = UIColor(red: 0.00, green: 0.66, blue: 0.59, alpha: 1.00)
        
        selectMapBtn.layer.cornerRadius = 8
        selectMapBtn.backgroundColor = UIColor(red: 0.20, green: 0.25, blue: 0.36, alpha: 1.00)
        
        challengeModeBtn.layer.cornerRadius = 8
        challengeModeBtn.backgroundColor = UIColor(red: 0.85, green: 0.38, blue: 0.49, alpha: 1.00)
        
        
        nameLabel.textColor = UIColor(red: 0.20, green: 0.25, blue: 0.36, alpha: 1.00)
        
        currentUserScoreLabel.textColor = UIColor(red: 0.00, green: 0.66, blue: 0.59, alpha: 1.00)
        currentUserScoreLabel.backgroundColor = UIColor(red: 0.95, green: 0.98, blue: 0.93, alpha: 1.00)
        
        challengeScoreLabel.textColor = UIColor(red: 0.97, green: 0.50, blue: 0.00, alpha: 1.00)
        challengeScoreLabel.backgroundColor = UIColor(red: 0.95, green: 0.98, blue: 0.93, alpha: 1.00)
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOut(_ sender: Any) {
        let userInfos:NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
        if let users = try? AppDelegate.viewContext.fetch(userInfos) {
            for user in users {
                AppDelegate.viewContext.delete(user)
            }
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
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
