//
//  ScoreTableViewController.swift
//  geoapp
//
//  Created by nguyen thanh vy on 25/04/2020.
//  Copyright © 2020 team geo app. All rights reserved.
//

import UIKit
import Firebase

class UserScoreTableViewController: UITableViewController{
    
    var databaseHandle:DatabaseHandle?
    var scoresArray = [Int]()
    var usernameArray = [String]()
    var countAr: Int = 0
    @IBOutlet var normalTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        normalTable.accessibilityIdentifier = "normalTable"
        
        Helpers.databaseRef.child("scores").observe(.value, with: { (snapshot) in
            let score = snapshot.value as! NSDictionary
            
            print("score", score)
            for (_, value) in score {
                //let currentKey = key as! String
                let currentNormalValue = (value as! NSDictionary)[Helpers.normalMode] as! Int
                self.scoresArray.append(currentNormalValue)
                //self.usernameArray.append(currentKey)
            }
            self.scoresArray.sort()
            self.scoresArray.reverse() //higher scores first
            repeat{
                for (key, value) in score {
                    let currentKey = key as! String
                    let currentNormalValue = (value as! NSDictionary)[Helpers.normalMode] as! Int
                    //self.scoresArray.append(currentNormalValue)
                    if currentNormalValue == self.scoresArray[self.countAr]
                    {
                        self.usernameArray.append(currentKey)
                    }
                }
                self.countAr += 1
            }while(self.countAr < self.scoresArray.count)
            
            //self.scoresArray = self.scoresArray.sort()
            /* sort by name
             for (key, _) in score {
                let currentKey = key as! String
                //self.scoresArray.append(currentNormalValue)
                self.usernameArray.append(currentKey)
            }
            self.usernameArray.sort()
            repeat{
            for (key, value) in score {
                let currentNormalValue = (value as! NSDictionary)[Helpers.normalMode] as! NSNumber
                if (key as! String).isEqual(self.usernameArray[self.countAr]){
                    self.scoresArray.append(currentNormalValue)
                }
                //self.scoresArray.append(currentNormalValue)
                //self.usernameArray.append(currentKey)
            }
                self.countAr += 1
            }while(self.countAr < self.usernameArray.count)*/
            
//            self.scoresArray = score.allValues as! [NSNumber]
//            self.usernameArray = score.allKeys as! [String]
            
            // customize the tableview
            self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.backgroundColor = UIColor(red: 0.00, green: 0.19, blue: 0.29, alpha: 1.00)
    
            
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return scoresArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    

    // Make the background color show through
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    //height for each row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // Set the spacing between sections
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
           return 30;
        }else {
            return 15;
        }

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "scoreItemCell", for: indexPath) as? UserScoreTableViewCell else {
            fatalError("The dequeued cell is not an instance of UserScoreTableViewCell.")
        }
        
        cell.scoreLabel?.text = String(scoresArray[indexPath.section])
        cell.usernameLabel?.text = usernameArray[indexPath.section]
        
        // add border and color
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        cell.scoreLabel?.textColor = UIColor(red: 0.97, green: 0.50, blue: 0.00, alpha: 1.00)
        cell.usernameLabel?.textColor = UIColor(red: 0.00, green: 0.19, blue: 0.29, alpha: 1.00)
        
        
        return cell
    }
    

    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
