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
        return tv
    }()
    
    var packages = [PFObject]()
    var currentUser = PFUser.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className:"Packages")
        query.whereKey("author", equalTo: currentUser!)
        query.limit = 20
        
        query.findObjectsInBackground { (packages, error) in
            if packages != nil {
                self.packages = packages!
                self.tableview.reloadData()
            }
        
        }
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.7607843137, blue: 0.5568627451, alpha: 1)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.separatorStyle = UITableViewCell.SeparatorStyle.none
        
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
        cell.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.7607843137, blue: 0.5568627451, alpha: 1)
        // cell.trackingNumber.text = "Tracking Number: \(packages[indexPath.row]["tracking_number"] as! String)"
        cell.trackingNumberLabel.text = packages[indexPath.row]["tracking_number"] as? String
        cell.carrierLabel.text = packages[indexPath.row]["carrier"] as? String
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let cell = tableview.cellForRow(at: indexPath) as! PackageTableViewCell
        // print(cell.trackingNumber.text!)
        // self.present(TrackViewController, animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "TrackViewController") as! UINavigationController
        let trackViewController = nav.topViewController as! TrackViewController
        let trackNum = packages[indexPath.row]["tracking_number"] as? String
        let carrier = packages[indexPath.row]["carrier"] as? String
        trackViewController.setTrackingNumAndCarrier(trackNum, carrier)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
    // override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //     if let nav = segue.destination as? UINavigationController, let trackViewController = nav.topViewController as? TrackViewController {
    //         trackViewController.setTrackingNumAndCarrier(trackNumInput.text, carrierInput.text)
    //     }
    // }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
