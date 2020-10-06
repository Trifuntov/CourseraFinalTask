//
//  ProfileVC.swift
//  Course2FinalTask
//
//  Created by Igor Trifuntov on 29.06.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class ProfileVC: UIViewController {
    
    var user: User?
    var imagePosts: [UIImage] = []
    let blackView = BlackView()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //регистрация nib header для collectionView
        collectionView.register(UINib(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        blackView.activity(view: view.self)
        loadData()
        
        //scroll to top
        collectionView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        imagePosts.removeAll()
        //        user = nil
        //        navigationItem.title = ""
        //        collectionView.reloadData()
    }
    
    // MARK: - Function
    
    func loadData() {
        let group = DispatchGroup()
        group.enter()
        if UserIDSet.shared.userID != nil {
            DataProviders.shared.usersDataProvider.user(with: UserIDSet.shared.userID!, queue: DispatchQueue.global()) { (user) in
                guard user != nil else { return }
                self.user = user
                
                DataProviders.shared.postsDataProvider.findPosts(by: user!.id, queue: DispatchQueue.global()) { (posts) in
                    for i in posts! {
                        self.imagePosts.append(i.image)
                    }
                    group.leave()
                }
            }
        } else {
            
            guard let user = UserIDSet.shared.currentUser else { return }
            DataProviders.shared.postsDataProvider.findPosts(by: user.id, queue: DispatchQueue.global()) { (posts) in
                self.user = user
                for i in posts! {
                    self.imagePosts.append(i.image)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.navigationItem.title = "\(self.user!.username)"
            self.collectionView.reloadData()
            self.blackView.stopActivity()
        }
    }
}

// MARK: - CollectionView

extension ProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagePosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
        cell.imageCell.image = self.imagePosts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // Header Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 86)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    //        return CGSize(width: UIScreen.main.bounds.width, height: 50)
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
    }
    
    
    // отобразить header для collectionView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderView
        
        guard let user = self.user else { return headerView }
        headerView.setProfile(user: user)
        headerView.followers.addTarget(nil, action: #selector(followersAction), for: .touchUpInside)
        headerView.following.addTarget(nil, action: #selector(followingAction), for: .touchUpInside)
        return headerView
    }
}


class CollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageCell: UIImageView!
}

extension ProfileVC {
    @objc func followersAction() {
        guard let user = self.user else { return }
        let vcID = "UsersTableVC"
        let vc = storyboard?.instantiateViewController(withIdentifier: vcID)
        let vcData = vc as! UsersTableVC?
        vcData?.user = user
        vcData?.set = .followers
        self.navigationController!.pushViewController(vc!, animated: true)
    }
    
    @objc func followingAction() {
        guard let user = self.user else { return }
        let vcID = "UsersTableVC"
        let vc = storyboard?.instantiateViewController(withIdentifier: vcID)
        let vcData = vc as! UsersTableVC?
        vcData?.user = user
        vcData?.set = .following
        self.navigationController!.pushViewController(vc!, animated: true)
    }
}
