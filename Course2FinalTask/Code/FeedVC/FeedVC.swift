//
//  FeedVC.swift
//  Course2FinalTask
//
//  Created by Igor Trifuntov on 27.06.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class FeedVC: UIViewController, MyCellDelegate {
    
    private var posts = [Post]()
    private var currentUser: User?
    let blackView = BlackView()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib.init(nibName: "MyCell", bundle: nil), forCellReuseIdentifier: "MyCell")
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        blackView.activity(view: view.self)
        UserIDSet.shared.userID = nil
        feedLoad()
    }
    
    
    // MARK: - Func feedArray, Like, BigLike, Avatar Button
    
    func feedLoad(){
        DataProviders.shared.postsDataProvider.feed(queue: DispatchQueue.global(qos: .userInitiated)) { posts in
            if let posts = posts {
                DispatchQueue.main.async {
                    self.posts = posts
                    self.tableView.reloadData()
                    self.blackView.stopActivity()
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    self.blackView.stopActivity()
                    AlertMessage().addAlert(controller: self, navigation: nil)
                }
            }
        }
    }
    
    func likeButton(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        like(indexPath: indexPath)
    }
    
    func doubleTapLike(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        guard !posts[indexPath.row].currentUserLikesThisPost else { return }
        like(indexPath: indexPath)
    }
    
    //func button переход на ProfileVC
    func userBtn(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        UserIDSet.shared.userID = posts[indexPath.row].author
        self.tabBarController?.selectedIndex = 2
    }
    
    func like(indexPath: IndexPath) {
        let queue = DispatchQueue(label: "MyQueue", qos: .userInteractive, attributes: .concurrent)
        let group = DispatchGroup()
        group.enter()
        if self.posts[indexPath.row].currentUserLikesThisPost {
            DataProviders.shared.postsDataProvider.unlikePost(with: self.posts[indexPath.row].id, queue: queue) { (post) in
                guard let post = post else { return }
                group.leave()
            }
        } else {
            DataProviders.shared.postsDataProvider.likePost(with: self.posts[indexPath.row].id, queue: queue) { (post) in
                guard let post = post else { return }
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.global()) {
            DataProviders.shared.postsDataProvider.feed(queue: queue) { posts in
                guard let posts = posts else { return }
                self.posts[indexPath.row] = posts[indexPath.row]
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
    }
}

// MARK: - TableView
extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! MyCell
        
        //выбор ячейки без выделения - это не то же самое, что selection - no selection в настройках storyboard
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.delegate = self
        //cell.setCell(post: posts[indexPath.row])
        cell.setCell(post: posts[indexPath.row])
        return cell
    }
}


