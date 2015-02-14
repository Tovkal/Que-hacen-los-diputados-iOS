//
//  ParlamentarioTVC.swift
//  Que hacen los diputados
//
//  Created by Andrés Pizá on 13/2/15.
//  Copyright (c) 2015 tovkal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DiputadosTVC: UITableViewController {
    
    let url = "http://api.quehacenlosdiputados.net/diputados"
    
//    private var diputados = JSON.nullJSON
    private var diputados: JSON = [["id":"87", "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":"87", "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":"87", "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":"87", "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":"87", "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":"87", "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":"87", "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":"87", "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":"87", "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":"87", "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":"87", "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":"87", "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.navigationController?.tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        
        //fetchData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        animateTable()
    }
    
    private func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells()
        let tableHeight = tableView.bounds.size.height
        
        // Move all cells to the bottom of the screen
        for c in cells {
            let cell = c as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        for c in cells {
            let cell = c as UITableViewCell
            UIView.animateWithDuration(1.2, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0)
                }, completion: nil)
            
            index++
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.diputados.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ParlamentarioCell", forIndexPath: indexPath) as UITableViewCell
        
        
        let surnameAttributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(16.0)]

        var fullName = NSMutableAttributedString(string: self.diputados[indexPath.row]["apellidos"].string!, attributes: surnameAttributes)
        
        let name = self.diputados[indexPath.row]["nombre"].string!
        
        fullName.appendAttributedString(NSAttributedString(string: ", \(name)"))
        
        cell.textLabel?.attributedText = fullName

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    func fetchData() {
        Alamofire.request(.GET, url, parameters: ["only": "[\"id\",\"nombre\",\"apellidos\",\"partido\"]"])
            .responseJSON { (req, res, json, error) in
                if(error != nil) {
                    NSLog("Error: \(error)")
                    println(req)
                    println(res)
                }
                else {
                    NSLog("Success: \(self.url)")
                    self.diputados = JSON(json!)
                    self.animateTable()
                }
        }
    }

}
