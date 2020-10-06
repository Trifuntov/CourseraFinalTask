//
//  UsersTableVC.swift
//  Course2FinalTask
//
//  Created by Igor🛠iOSDev on 8/10/20.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class UsersTableVC: UITableViewController {
    
    var set: setFollow!
    var usersArray = [User]()
    let blackView = BlackView()
    var user: User?
    
    enum setFollow {
        case followers
        case following
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "UsersTableCell", bundle: nil), forCellReuseIdentifier: "UsersTableCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        blackView.activity(view: view.self)
        loadData()
    }
   
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        usersArray = [User]()
        navigationController?.popToRootViewController(animated: false)
    }
    
    func loadData() {
        
        var usersArray = [User]()
        let queue = DispatchQueue(label: "queue", qos: .userInteractive, attributes: .concurrent)
        let group = DispatchGroup()
        
        switch set {
        case .followers:
            navigationItem.title = "Followers"
            
            group.enter()
            guard let user = self.user else { return }
            DataProviders.shared.usersDataProvider.usersFollowingUser(with: user.id, queue: queue) { (users) in
                guard let users = users else { return }
                usersArray = users
                group.leave()
            }
            group.notify(queue: .main) {
                self.usersArray = usersArray
                self.blackView.stopActivity()
                self.tableView.reloadData()
            }
            
        case .following:
            navigationItem.title = "Following"
            group.enter()
            guard let user = self.user else { return }
            DataProviders.shared.usersDataProvider.usersFollowedByUser(with: user.id, queue: queue) { (users) in
                guard let users = users else { return }
                usersArray = users
                group.leave()
            }
            group.notify(queue: .main) {
                self.usersArray = usersArray
                self.blackView.stopActivity()
                self.tableView.reloadData()
            }
        default:
            return
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersTableCell", for: indexPath) as! UsersTableCell
        
        cell.name.text = usersArray[indexPath.row].fullName
        cell.imageUser.image = usersArray[indexPath.row].avatar
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserIDSet.shared.userID = usersArray[indexPath.row].id
        navigationController?.popToRootViewController(animated: true)
    }
}
