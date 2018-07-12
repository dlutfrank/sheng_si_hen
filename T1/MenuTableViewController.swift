//
//  MenuTableViewController.swift
//  T1
//
//  Created by Rong GONG on 24/05/2018.
//  Copyright © 2018 MTG NACTA. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    var menuItems = ["头面介绍", "化妆介绍", "服装介绍", "身段教学", "便装教学", "带装教学", "文章", "演职人员名单"]
    
    let back_ground_horizontal = ImageUtils.blurImage(image: UIImage(named: "back_ground_horizontal.jpg")!)
    let back_ground_vertical = ImageUtils.blurImage(image: UIImage(named: "back_ground_vertical.jpg")!)
    
    private func loadHorizontalBG() {
        tableView.backgroundView = UIImageView(image: back_ground_horizontal)
        tableView.backgroundView?.backgroundColor = UIColor .white
        tableView.backgroundView?.contentMode = .scaleToFill
    }
    
    private func loadVerticalBG() {
        tableView.backgroundView = UIImageView(image: back_ground_vertical)
        tableView.backgroundView?.backgroundColor = UIColor .white
        tableView.backgroundView?.contentMode = .scaleToFill
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            loadHorizontalBG()
        } else {
            loadVerticalBG()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
                                
        if  (UIApplication.shared.statusBarOrientation.isLandscape) {
            loadHorizontalBG()
        } else {
            loadVerticalBG()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MenuTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MenuTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MenuTableViewCell.")
        }
        
        let item_name = menuItems[indexPath.row]
        
        cell.menuItemLabel.text = item_name
        
        cell.menuItemLabel.tag = indexPath.row

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        
        if cell?.reuseIdentifier == "MenuTableViewCell" {
            if indexPath.row < 6 {
                self.performSegue(withIdentifier: "showVideoTableView", sender: self)
            } else {
                self.performSegue(withIdentifier: "showWebView", sender: self)
            }
        }
        
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow{
            if indexPath.row < 6 {
                let videoTableVC = segue.destination as! VideoTableViewController
                videoTableVC.row_segue_received = indexPath.row
            } else {
                let webViewVC = segue.destination as! WebViewController
                switch indexPath.row {
                case 6:
                    webViewVC.url_string = "https://ronggong.github.io/projects/nacta_sheng_si_hen/articles.html"
                case 7:
                    webViewVC.url_string = "https://ronggong.github.io/projects/nacta_sheng_si_hen/persons.html"
                default:
                    webViewVC.url_string = "https://www.google.com"
                }
            }
        }
    }
    
    @IBAction func returnButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
