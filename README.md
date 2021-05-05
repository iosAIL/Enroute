# Enroute
#### Authors: Iman Ali, Lincoln Nguyen and Amber Lin

## Table of Contents
1. [Overview](#Overview)
3. [Product Spec](#Product-Spec)
5. [Wireframes](#Wireframes)
6. [Schema](#Schema)

## Overview
### Description
__Enroute__ is a package tracking app that stores and tracks shipments of multiple packages in one app.

### App Evaluation
- **Category:** Utilities
- **Mobile:** No website, does not use camera, mobile only experience.
- **Story:** Allows user to track current location of their packages.
- **Market:** Anyone who buys things online.
- **Habit:** App organizes packages from numerous different carriers into one app. Very convenient!
- **Scope:** For now we are focused on completing functionality for tracking multiple packages and enabling push notifications.

## Product Spec
    - store user information
    - store packages' information
    - display all packages' locations in a table when user is logged in
    - display tracking history when a package in the table is tapped
    - notify user when a package is arriving the next day

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [X] User can add a package using tracking id
- [X] User can view latest location of package
- [X] User can signUp, signIn, logout and stay logged in
- [X] User can pull to refresh
- [X] Styled icon, launch screen and custom style for app
- [X] Username and num packages expecting displayed at top of list view
- [X] User can view status of packages in list view
- [X] Color of cell icon changes according to delivery status
- [ ] User will receive a notification when the package is delivered

**Optional Nice-to-have Stories**

- [ ] User can sort packages by estimated arrival time
- [X] User can remove a package from the list
- [X] User can view past locations of package and its arrival times at those locations

### Milestone 1 demo
<img src='http://g.recordit.co/VLTLTC6tXQ.gif' />
GitHub cut off part of GIF I think, here is full GIF showing persistence of login/logout states:
https://recordit.co/VLTLTC6tXQ

### Milestone 2 demo
<img src='http://g.recordit.co/2o84abJsc4.gif' />

### 2. Screen Archetypes

* Login
   * User can login
* Register
   * User can create a new account 
* Packages
    * User can view status and latest location of all packages
* Add Package
    * User can add packages (by entering carrier and tracking number)
* Package Route
    * User can view past locations of package and its arrival times at those locations

### 3. Navigation

**Flow Navigation** (Screen to Screen)
* Login
    * Register
    * Packages
* Register
    * Login (back)
    * Packages (confirm)
* Packages
    * Package Route
    * Add Package
* Add Package
    * Packages (add)
    * Packages (back)
* Package Route
    * Packages (back)

## Wireframes!
<img src="https://user-images.githubusercontent.com/61459043/113426078-8cb64680-9398-11eb-90f2-35a54148d594.jpeg" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
### Models
#### Package

   | Property        | Type     | Description |
   | ----------------| -------- | ------------|
   | author          | String   | current user's username |
   | tracking_number | String   | tracking number of package|
   | carrier         | String   | carrier of package |
   | status          | String   | status of package |
   
#### Author
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | username      | string   | username of user account |
   | email         | string   | email of user account |
   | password      | string   | password of user account|
   | packages      | List     | a list of pointer to author's package|
   
   
### Networking
#### List of network requests by screen
- Packages Screen
    - (Read/GET) Query all packages where user is author
    ```swift
    let query = PFQuery(className:"Package")
    query.whereKey("author", equalTo: currentUser)
    query.order(byDescending: "order_create_time")
    query.findObjectsInBackground { (packages: [PFObject]?, error: Error?) in
       if let error = error {
          print(error.localizedDescription)
       } else if let posts = posts {
          print("Successfully retrieved \(packages.count) packages.")
          // TODO: Do something with posts...
       }
    } 
    ```
    
    - (Delete) Delete all packages
    ```swift
    PFObject.deleteAll(inBackground: objectArray) { (succeeded, error) in
        if (succeeded) {
        // The array of objects was successfully deleted.
        } else {
        // There was an error. Check the errors localizedDescription.
        }
    }
    ```
    - (Delete) Delete one package
    ```swift
    var query = PFQuery(className:"Packages")
    query.whereKey("tracking_number", equalTo: "\(PFUser.currentUser()?.tracking_number)")
    query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
        if let error = error {
          print(error.localizedDescription)
        } else {
            for object in objects {
                object.deleteInBackground()
            }
        }
    })
    ```
    
- Login Screen
    - (Read/GET) Query logged in user object
    ```swift
    var currentUser = PFUser.current()
    if currentUser != nil {
         // Do stuff with the user
    } else {
        // Show the signup or login screen
    }
    ```

    -  User log in
    ```swift
    PFUser.logInWithUsername(inBackground:"myname", password:"mypass") {
    (user: PFUser?, error: Error?) -> Void in
        if user != nil {
        // Do stuff after successful login.
        } else {
        // The login failed. Check error to see why.
        }
    }
    ```

- Register Screen
    - (Create) Create a new user
    ```swift
    var user = PFUser()
  user.username = "myUsername"
  user.password = "myPassword"
  user.email = "email@example.com"

  user.signUpInBackground {
    (succeeded: Bool, error: Error?) -> Void in
    if let error = error {
      let errorString = error.localizedDescription
      // Show the errorString somewhere and let the user try again.
    } else {
      // Hooray! Let them use the app now.
    }
  }
    ```
    
- Add Package Screen
    - (Create/POST) Create a new package object
     ```swift
    let package = PFObject(className:"Packages")
    package["author"] = PFUser.current()!
    package["tracking_number"] = "LS912989618CN"
    package["carrier"] = "ups"
    package["status"] = "transit"
    package.saveInBackground { (succeeded, error)  in
    if (succeeded) {
        // The object has been saved.
    } else {
        // There was a problem, check error.description
    }
     ```
     
- Package Route Screen 
    - (POST) Get realtime tracking info for a package
    ```swift
    // Get package tracking info from API
    let headers = [
	    "content-type": "application/json",
	    "x-rapidapi-key": "133c06b141msh9e7797127c6e6eep1ca795jsnc5e3c1f5762c",
	    "x-rapidapi-host": "order-tracking.p.rapidapi.com"]
    let parameters = [
	    "tracking_number": "1Z74A08E0317341984",
	    "carrier_code": "ups"] as [String : Any]

    let postData = JSONSerialization.data(withJSONObject: parameters, options:[])

    let request = NSMutableURLRequest(url: NSURL(string: "https://ordertracking.p.rapidapi.com/trackings/realtime")! as URL,
    cachePolicy: .useProtocolCachePolicy, 
    timeoutInterval: 10.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData as Data

    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
	    if (error != nil) {
		    print(error)
	    } else {
		    let httpResponse = response as? HTTPURLResponse
		    print(httpResponse)
	    }
    })

    dataTask.resume()
 
     ```


#### [OPTIONAL:] Existing API Endpoints   
##### Order Tracking API
- Base URL - [https://www.ordertracking.com/api-index.html](http://www.anapioficeandfire.com/api)

 | HTTP Verb | Endpoint | Description
   ----------|----------|------------
 |   `POST`    | /trackings/realtime | Get realtime tracking info for one package
 |   `GET`    | /carriers | List all carriers
    
