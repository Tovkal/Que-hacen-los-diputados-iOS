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
    
    private var diputados = JSON.nullJSON
    //private var diputados: SwiftyJSON.JSON = [["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"],["id":87, "nombre":"Juan Antonio", "apellidos":"Abad Pérez", "partido":"PP"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.navigationController?.tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        
        fetchData()
        
        var nib = UINib(nibName: "DeputyTableViewCell", bundle: nil)
        
        tableView.registerNib(nib, forCellReuseIdentifier: "DeputyCell")
        
        // Self-sizing table view cells in iOS 8 require that the rowHeight property of the table view be set to the constant UITableViewAutomaticDimension
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Self-sizing table view cells in iOS 8 are enabled when the estimatedRowHeight property of the table view is set to a non-zero value.
        // Setting the estimated row height prevents the table view from calling tableView:heightForRowAtIndexPath: for every row in the table on first load;
        // it will only be called as cells are about to scroll onscreen. This is a major performance optimization.
        tableView.estimatedRowHeight = 100.0 // set this to whatever your "average" cell height is; it doesn't need to be very accurate
        
        
        // Nav bar buttons
        let exdiputados = UIBarButtonItem(title: "Exdiputados", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        let filter = UIBarButtonItem(image: UIImage(named: "Filter"), style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        let sort = UIBarButtonItem(image: UIImage(named: "Sort"), style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        
        let rightButtonsArray = [sort, filter]
        
        self.navigationItem.leftBarButtonItem = exdiputados
        self.navigationItem.rightBarButtonItems = rightButtonsArray
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
            let cell = c as! UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        for c in cells {
            let cell = c as! UITableViewCell
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DeputyCell") as! DeputyTableViewCell

        cell.layoutIfNeeded()

        // Build name string
        let surnameAttributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(12)]
        var fullName = NSMutableAttributedString(string: self.diputados[indexPath.row]["apellidos"].string!, attributes: surnameAttributes)
        let name = self.diputados[indexPath.row]["nombre"].string!
        fullName.appendAttributedString(NSAttributedString(string: ", \(name)"))
        
        // Deputy image url
        let deputyId = self.diputados[indexPath.row]["id"].int!
        var profileURL = NSURL(string: "http://quehacenlosdiputados.net/img/imagenesDipus/\(deputyId).jpg")
        
        // Party image url
        let partyName = self.diputados[indexPath.row]["partido"].string!
        // Remove accents (i.e. COMPROMÍS -> COMPROMIS)
        let normalizedPartyName = NSString(data: partyName.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!, encoding: NSASCIIStringEncoding)!
        var partyURL = NSURL(string: "http://quehacenlosdiputados.net/img/miniaturasPartidos/\(normalizedPartyName).png")
        
        // Party image
        cell.party.sd_setImageWithURL(partyURL)
        
        // Profile image
        SDWebImageManager.sharedManager().downloadImageWithURL(profileURL, options: nil, progress: {
            receivedSize, expectedSize in
            if receivedSize != expectedSize {
                
            }
            }, completed: {
                image, error, a , c ,s in
                if image != nil {
                    cell.setProfileImage(image.cropImage(CGRectMake(0, 0, 150, 120)))
                }
        })
        
        // Deputy name
        cell.name.attributedText = fullName
        
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()

        return cell
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
