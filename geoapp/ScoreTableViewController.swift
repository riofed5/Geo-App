//
//  ScoreTableViewController.swift
//  geoapp
//
//  Created by nguyen thanh vy on 25/04/2020.
//  Copyright © 2020 team geo app. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ScoreTableViewController: UITableViewController{
    
    var ref:FirebaseDatabaseReference?
    var databaseHandle:FIRDatabaseHandle?
    var postData = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the firebase reference
        ref = FirebaseDatabase.database().reference()
        
        // Retrieve the posts and listen for changes
        ref?.child("users").child("test").observe(.childAdded, with: { (FIRDataSnapshot) in
            // Code to execute when a child is added under "Posts"
            // Take the value from the snapshot and added it to the postData array
            let post = snapshot.value as? String
            
            if let actualPost = post {
                self.postData.append(actualPost)
                
                //Reload the tableview
                tableView.reloadData()
            }
            self.postData.append("")
        })
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreItemCell", for: indexPath)

        

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
