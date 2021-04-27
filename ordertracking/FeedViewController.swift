//
//  FeedViewController.swift
//  ordertracking
//
//  Created by Iman Ali on 4/17/21.
//

import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var expectingLabel: UILabel!
    
    var packages = [PFObject]()
    var currentUser = PFUser.current()
    var trackingNum = "";
    var carrier = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userLabel.text = currentUser?.username
        expectingLabel.text = "Expecting " + String(packages.count) + " packages"
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.7607843137, blue: 0.5568627451, alpha: 1)
        self.view.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.7607843137, blue: 0.5568627451, alpha: 1)
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
    //delete package
    func tableView(_ tableView: UITableView, commit editingStyle:UITableViewCell.EditingStyle,forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let objId=(packages[indexPath.row].objectId)!
            let query = PFQuery(className:"Packages")
            query.getObjectInBackground(withId: objId) {
            (parseObject, error) in
               if error != nil {
                print(error!)
               } else if parseObject != nil {
                self.tableview.beginUpdates()
                self.packages.remove(at: indexPath.row)
                self.tableview.deleteRows(at: [indexPath], with: .fade)
                parseObject?.deleteInBackground()
                self.tableview.endUpdates()
                    
               }
             }
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginViewController.modalPresentationStyle = .fullScreen
        self.present(loginViewController, animated: true)
    }
    
    /*func setupTableView() {
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
    }*/
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! PackageTableViewCell
        let cell = tableview.dequeueReusableCell(withIdentifier: "PackageTableViewCell", for: indexPath) as! PackageTableViewCell
        
        self.trackingNum = packages[indexPath.row]["tracking_number"] as! String
        self.carrier = packages[indexPath.row]["carrier"] as! String
        cell.trackingNumberLabel.text = self.trackingNum
        cell.carrierLabel.text = self.carrier
        cell.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.7607843137, blue: 0.5568627451, alpha: 1)
        
        sendRequest() { data in
            DispatchQueue.main.async {
                cell.statusLabel.text = data
            }
        }
        
        // cell.trackingNumber.text = "Tracking Number: \(packages[indexPath.row]["tracking_number"] as! String)"
        cell.nameLabel.text = packages[indexPath.row]["name"] as? String
        
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
        trackViewController.packageName = packages[indexPath.row]["name"] as! String
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
    func sendRequest(completion: @escaping (String)->()) {
        var returnData = "Loading status..."
        let headers = [
            "content-type": "application/json",
            "x-rapidapi-key": "c6e12970f5msh258f9543aba75efp155d01jsn8923c7e612e6",
            "x-rapidapi-host": "order-tracking.p.rapidapi.com"
        ]
        let parameters = [
            "tracking_number": self.trackingNum,
            "carrier_code": self.carrier
        ] as [String : Any]
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let request = NSMutableURLRequest(url: NSURL(string: "https://order-tracking.p.rapidapi.com/trackings/realtime")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            let session = URLSession.shared
            session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                if (error != nil) {
                    print(error!)
                } else if let data = data {
                    let httpResponse = response as? HTTPURLResponse
                    // print(httpResponse)
                    // let trackingData = String(decoding: data!, as: UTF8.self)
                    // print(trackingData)
                    // if (trackingData != nil) {
                    //     returnValue = trackingData
                    // }
                    // print(data)
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                    // print(dataDictionary)
                    let packageInfo = dataDictionary["data"] as! [String : Any]
                    // print(packageInfo)
                    if packageInfo["items"] == nil {
                        return completion("Package not found.")
                    }
                    let items = packageInfo["items"] as! [[String:Any]]
                    // print(items)
                    let lastEvent = items[0]["lastEvent"] as! String
                    if (lastEvent.count <= 0) {
                        return completion("Package not found.")
                    }
                    print(lastEvent)
                    let lastUpdateTime = items[0]["lastUpdateTime"] as! String
                    // print(lastUpdateTime)
                    let originInfo = items[0]["origin_info"] as! [String:Any]
                    // print(originInfo)
                    let trackInfo = originInfo["trackinfo"] as! [[String:Any]]
                    
                    // returnData = trackInfo[0]["checkpoint_status"] as! String
                    
                    let status = trackInfo[0]["checkpoint_status"] as! String
                    let time = trackInfo[0]["Date"]  as! String
                    
                    returnData = "\(status)   \(time)"
                    
                    // print(trackInfo)
                    // returnData = trackInfo
                    // returnData = lastEvent
                    // returnData["lastEvent"] = lastEvent
                    // returnData["lastUpdateTime"] = lastUpdateTime
                    // print(returnData)
                    return completion(returnData)
                }
            }).resume()
        } catch {
            print(error)
        }
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
