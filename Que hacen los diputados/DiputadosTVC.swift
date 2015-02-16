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
    
    //private var diputados = JSON.nullJSON
    private var diputados: JSON = [["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.navigationController?.tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        
        //fetchData()
        
        var nib = UINib(nibName: "DeputyTableViewCell", bundle: nil)
        
        tableView.registerNib(nib, forCellReuseIdentifier: "DeputyCell")
        
        // Self-sizing table view cells in iOS 8 require that the rowHeight property of the table view be set to the constant UITableViewAutomaticDimension
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Self-sizing table view cells in iOS 8 are enabled when the estimatedRowHeight property of the table view is set to a non-zero value.
        // Setting the estimated row height prevents the table view from calling tableView:heightForRowAtIndexPath: for every row in the table on first load;
        // it will only be called as cells are about to scroll onscreen. This is a major performance optimization.
        tableView.estimatedRowHeight = 100.0 // set this to whatever your "average" cell height is; it doesn't need to be very accurate
    }
    
    override func viewWillAppear(animated: Bool) {
        animateTable()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeCategoryChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    // This function will be called when the Dynamic Type user setting changes (from the system Settings app)
    func contentSizeCategoryChanged(notification: NSNotification) {
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
        let cell = tableView.dequeueReusableCellWithIdentifier("DeputyCell") as DeputyTableViewCell
        
        // Build name string
        let surnameAttributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(16.0)]
        var fullName = NSMutableAttributedString(string: self.diputados[indexPath.row]["apellidos"].string!, attributes: surnameAttributes)
        let name = self.diputados[indexPath.row]["nombre"].string!
        fullName.appendAttributedString(NSAttributedString(string: ", \(name)"))
        
        // Set cell attributes
        cell.name.attributedText = fullName
        cell.imageView?.image = downloadProfileImage(self.diputados[indexPath.row]["id"].int!)
        
        // Make sure the constraints have been added to this cell, since it may have just been created from scratch
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()

        return cell
    }
    
    func downloadProfileImage(id: Int) -> UIImage? {
        let imgURL: NSURL = NSURL(string: "http://quehacenlosdiputados.net/img/imagenesDipus/\(id).jpg")!
        
        // Download an NSData representation of the image at the URL
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        var response = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        
        var image = UIImage(data: response!)
        
        return image
        
                
        /*NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
            if !(error? != nil) {
                var image = UIImage(data: data)
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.imageView.image = image
                })
            }
            else {
                println("Error: \(error.localizedDescription)")
            }
        })*/
    }
    
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
