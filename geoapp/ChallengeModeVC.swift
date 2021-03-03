//
//  StreetViewController.swift
//  geoapp
//
//  Created by iosdev on 1.5.2020.
//  Copyright © 2020 team geo app. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import MapKit
import Foundation
import CoreData

class ChallengeModeVC: UIViewController {

    @IBOutlet weak var panoramaView: GMSPanoramaView!
    @IBOutlet weak var guessBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var currentScore: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var cdownLbl: UILabel!
    
    let service = GMSPanoramaService()
    var latCor: Double = 0.00
    var longCor: Double = 0.00
    var panoramaIDCheck:String = ""
    var timer = Timer()
    var seconds: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Helpers.isChallengeMode = true
        checkForPanorama()
        
        // set time for Timer
        seconds = 120
        // update question number & progress bar
        Helpers.questionNumber += 1
        currentScore.text = "\(Helpers.cha_score)"
        progressView.frame.size.width = (view.frame.size.width/5)*CGFloat(Helpers.questionNumber)
        
        // styling elements
        backBtn.layer.cornerRadius = 8
        backBtn.backgroundColor = UIColor(red: 0.97, green: 1.00, blue: 0.97, alpha: 1.00)

        guessBtn.layer.cornerRadius = 8
        guessBtn.backgroundColor = UIColor(red: 0.97, green: 1.00, blue: 0.97, alpha: 1.00)

        cdownLbl.backgroundColor = UIColor(red: 0.97, green: 1.00, blue: 0.97, alpha: 1.00)
        
        currentScore.backgroundColor = UIColor(red: 0.97, green: 1.00, blue: 0.97, alpha: 1.00)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.panoramaView.animate(to: GMSPanoramaCamera(heading: 90, pitch: 0, zoom: 1), animationDuration: 2)
        }
        startTimer()
    }
    override func viewDidDisappear(_ animated: Bool) {
        stopTimer()
    }

    
    func checkForPanorama() {
        let i = Int.random(in: 0 ... 236)
        let ranLatCor = Double.random(in: -0.05 ... 0.05)
        let ranLongCor = Double.random(in: -0.05 ... 0.05)
        
        self.latCor = (Helpers.places["latCor"]?[i])! + ranLatCor //Double.random(in: -90 ... 90)
        self.longCor = (Helpers.places["longCor"]?[i])! + ranLongCor//Double.random(in: -180 ... 180)
        
        service.requestPanoramaNearCoordinate(CLLocationCoordinate2D(latitude: self.latCor, longitude: self.longCor)) { (panorama, error) in
            if let error = error {
                // No panorama
                print("wrong coordinator")
                print(error.localizedDescription)
                self.checkForPanorama()
                return
            } else if let panorama = panorama {
                print("Panorama id: \(panorama.panoramaID)")
                let location = CLLocation(latitude: self.latCor, longitude: self.longCor)
                location.fetchCityAndCountry { city, country, error in
                    guard let city = city, let country = country, error == nil else { return }
                    print(city + ", " + country)
                }
                print(i)
                print(self.latCor)
                print(self.longCor)
                self.panoramaView.move(toPanoramaID: panorama.panoramaID)
            } else {
                print("Something went wrong")
            }
        }
        
    }
    func startTimer() {
        print("start timer")
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        cdownLbl.text = timeString(time: TimeInterval(seconds))
        if (seconds == 0 && Helpers.questionNumber < 5) {
            self.viewDidLoad()
        }
        if (seconds == 0 && Helpers.questionNumber == 5) {
            alert()
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func stopTimer() {
        print("stop timer")
        timer.invalidate()
    }
    
    func alert() {
        stopTimer()
        updateScore()
        let alertMessage = NSLocalizedString("You got %d points.", comment: "")
        let alertController = UIAlertController(title: NSLocalizedString("Finish", comment: ""), message: String.localizedStringWithFormat(alertMessage, Helpers.cha_score), preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action) -> Void in Helpers.showHomeView(self)
        })
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func delProgress() {
        Helpers.cha_score = 0
        Helpers.showHomeView(self)
    }
    
    func updateScore() {
        let userInfos:NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
        if let users = try? AppDelegate.viewContext.fetch(userInfos) {
           if users.count != 0 && Helpers.cha_score > Helpers.curcha_score {
           Helpers.databaseRef.child("scores/\(users[0].username!)/\(Helpers.challengeMode)").setValue(Helpers.cha_score)}
        }
    }
    
    @IBAction func alert2(_ sender: Any) {
        stopTimer()
        let alertController = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("Your progress will be lost.", comment: ""), preferredStyle: .alert)
        let confirm = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: {(action) -> Void in self.delProgress()
        })
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: {(action) -> Void in self.startTimer()
        })
        alertController.addAction(confirm)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? GuessMapVC
        vc?.answer_coor = CLLocationCoordinate2D(latitude: latCor, longitude: longCor)
    }
}
