# Enroute

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

* User can add a package using tracking id
* User can view latest location of package
* User will receive a notification when the package is delivered

**Optional Nice-to-have Stories**

* User can sort packages by estimated arrival time
* User can remove a package from the list
* User can view past locations of package and its arrival times at those locations

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
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
