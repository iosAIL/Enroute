//
//  FeedViewController.swift
//  ordertracking
//
//  Created by Iman Ali on 4/17/21.
//

import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
   
    
    let tableview: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorColor = UIColor.white
        return tv
    }()
    
    var packages = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className:"Packages")
        query.includeKey("author")
        //query.whereKey("author", equalTo: currentUser())
        query.limit = 20
        
        query.findObjectsInBackground { (packages, error) in
            if packages != nil {
                self.packages = packages!
                self.tableview.reloadData()
            }
        
        }
    }
    
    
    func setupTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.register(PackageTableViewCell.self, forCellReuseIdentifier: "cellId")
        
        view.addSubview(tableview)
        
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableview.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableview.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! PackageTableViewCell
        cell.backgroundColor = UIColor.white
        cell.dayLabel.text = "Day \(indexPath.row+1)"
        return cell
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(indexPath.row)
        // let cell = tableView.cellForRowAt(at: indexPath) as! PackageTableViewCell
        // let cell = tableView.cellForRowAt(indexPath)
        // print(cell.dayLabel.text)
        let cell = tableview.cellForRow(at: indexPath) as! PackageTableViewCell
        print(cell.dayLabel.text!)
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