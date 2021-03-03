//
//  AnswerVC.swift
//  geoapp
//
//  Created by iosdev on 24.4.2020.
//  Copyright © 2020 team geo app. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreData

class AnswerVC: UIViewController {
    
    @IBOutlet weak var ansText: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var ptsText: UITextField!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var nornextBtn: UIButton!
    @IBOutlet weak var answerStackView: UIStackView!
    @IBOutlet weak var finishBtn: UIButton!
    var descoordinate = CLLocationCoordinate2D()
    var answer_coor = CLLocationCoordinate2D()
    var score: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: answer_coor.latitude, longitude: answer_coor
            .longitude, zoom: 4)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        
        let answer = GMSMarker()
        answer.position = CLLocationCoordinate2D(latitude: answer_coor.latitude, longitude: answer_coor.longitude)
        answer.map = mapView
        answer.icon = GMSMarker.markerImage(with: .blue)
        
        let guessr = GMSMarker()
        guessr.position = CLLocationCoordinate2D(latitude: descoordinate.latitude, longitude: descoordinate.longitude)
        guessr.map = mapView
        
        let distance = GMSGeometryDistance(answer.position,descoordinate)/1000

        score = 5000*pow(2.712828, -distance/2000)
        
        let path = GMSMutablePath()
        path.add(answer.position)
        path.add(guessr.position)
        
        let polyline = GMSPolyline(path:path)
        polyline.map = mapView
        
        DispatchQueue.main.async
        {
          let bounds = GMSCoordinateBounds(path: path)
            mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 100))
        }
        
        let ansString = NSLocalizedString("Your guess is %d km away from the answer.", comment: "")
        let ptsString = NSLocalizedString("You scored %d/5000 points.", comment: "")
        ansText.text = String.localizedStringWithFormat(ansString, Int(distance))
        ptsText.text = String.localizedStringWithFormat(ptsString, Int(score))
        self.view.addSubview(answerStackView)
        
        //style the buttons
        ansText.textColor = UIColor(red: 0.10, green: 0.33, blue: 0.36, alpha: 1.00)
        ansText.backgroundColor = UIColor(red: 0.97, green: 1.00, blue: 0.97, alpha: 1.00)
        ansText.isUserInteractionEnabled = false
        
        ptsText.backgroundColor = UIColor(red: 0.10, green: 0.33, blue: 0.36, alpha: 1.00)
        ptsText.isUserInteractionEnabled = false
        
        if (Helpers.isChallengeMode == true && Helpers.questionNumber < 5) {
            self.view.addSubview(nextBtn)
            nextBtn.layer.cornerRadius = 8
            nextBtn.backgroundColor = UIColor(red: 0.90, green: 0.22, blue: 0.27, alpha: 1.00)
            Helpers.cha_score += Int(score)
            print(Helpers.cha_score)
        }
        
        if (Helpers.isChallengeMode == true && Helpers.questionNumber == 5) {
            self.view.addSubview(finishBtn)
            finishBtn.layer.cornerRadius = 8
            finishBtn.backgroundColor = UIColor(red: 0.90, green: 0.22, blue: 0.27, alpha: 1.00)
            Helpers.cha_score += Int(score)
            print(Helpers.cha_score)
            let userInfos:NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
            if let users = try? AppDelegate.viewContext.fetch(userInfos) {
                if (users.count != 0 && Helpers.cha_score > Helpers.curcha_score){
                Helpers.databaseRef.child("scores/\(users[0].username!)/\(Helpers.challengeMode)").setValue(Helpers.cha_score)
               }
            }
        }
        if (Helpers.isChallengeMode == false) {
            self.view.addSubview(nornextBtn)
            nornextBtn.layer.cornerRadius = 8
            nornextBtn.backgroundColor = UIColor(red: 0.25, green: 0.53, blue: 0.77, alpha: 1.00)
            Helpers.nor_score += Int(score)
            print("updated: \(Helpers.nor_score)")
            self.view.addSubview(homeBtn)
            homeBtn.layer.cornerRadius = 8
            homeBtn.backgroundColor = UIColor(red: 0.90, green: 0.22, blue: 0.27, alpha: 1.00)
            
        }
    }
    
    func highScore() {
        let userInfos:NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
        if let users = try? AppDelegate.viewContext.fetch(userInfos) {
           if Helpers.nor_score > Helpers.cur_score {
            Helpers.databaseRef.child("scores/\(users[0].username!)/\(Helpers.normalMode)").setValue(Helpers.nor_score)
           }
            Helpers.showHomeView(self)
        }
    }
    @IBAction func finish(_ sender: UIButton) {
        let formatString = NSLocalizedString("You got %d points.", comment: "")
        let alertController = UIAlertController(title: NSLocalizedString("Challenge mode", comment: ""), message: String.localizedStringWithFormat(formatString, Helpers.cha_score), preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action) -> Void in Helpers.showHomeView(self)
        })
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func norFinish(_ sender: UIButton) {
        let userInfos:NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
        if let users = try? AppDelegate.viewContext.fetch(userInfos) {
            if (users.count == 0) {
                Helpers.showMainView(self)
            }
            else {
                let formatString = NSLocalizedString("You got %d points.", comment: "")
                let alertController = UIAlertController(title: NSLocalizedString("Normal mode", comment: ""), message: String.localizedStringWithFormat(formatString, Helpers.nor_score), preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action) -> Void in self.highScore()
                })
                alertController.addAction(ok)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func nextTrial(_ sender: Any) {
        let userInfos:NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
        if let users = try? AppDelegate.viewContext.fetch(userInfos) {
            if (users.count == 0) {
                let alertController = UIAlertController(title: NSLocalizedString("This is trial mode.", comment: ""), message: nil, preferredStyle: .alert)
                let signup = UIAlertAction(title: NSLocalizedString("Sign Up", comment: ""), style: .default, handler: {(action) -> Void in Helpers.showRegisterView(self)
                })
                let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: nil)
                alertController.addAction(signup)
                alertController.addAction(cancel)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
