//
//  HeaderView.swift
//  Course2FinalTask
//
//  Created by Igor🛠iOSDev on 8/9/20.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class HeaderView: UICollectionReusableView {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var followers: UIButton!
    @IBOutlet weak var following: UIButton!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followButtonBlue: UIButton!
    
    var user: User?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = 35
        followButton.layer.cornerRadius = 6
        followButtonBlue.isHidden = true
    }
    
    func setProfile (user: User) {
        
        self.profileImage.image = user.avatar
        self.nameUser.text = user.fullName
        self.following.setTitle("Following: \(user.followsCount)", for: .normal)
        self.followers.setTitle("Followers: \(user.followedByCount)", for: .normal)
        self.user = user
        followButtonBlue.setTitle(user.currentUserFollowsThisUser ? " Unfollow " : " Follow ", for: .normal)
        if user.id == UserIDSet.shared.currentUser.id {
            followButtonBlue.isHidden = true
        } else {
            followButtonBlue.isHidden = false
        }
        
    }
    
    @IBAction func subscribe(_ sender: UIButton) {
        guard let user = user else { return }
        if user.currentUserFollowsThisUser {
            self.followButtonBlue.setTitle(" Follow ", for: .normal)
            self.followers.setTitle("Followers: \(user.followedByCount - 1)", for: .normal)
            DataProviders.shared.usersDataProvider.unfollow(user.id, queue: DispatchQueue.global()) { (userCheck) in
                if userCheck == nil {
                    DataProviders.shared.usersDataProvider.user(with: user.id, queue: DispatchQueue.global()) { (user) in
                        guard let user = user else { return }
                        self.user = user
                    }
                    DispatchQueue.main.async {
                        self.followButtonBlue.setTitle(user.currentUserFollowsThisUser ? " Unfollow " : " Follow ", for: .normal)
                        self.followers.setTitle("Followers: \(user.followedByCount)", for: .normal)
                    }
                }
            }
        } else {
            self.followButtonBlue.setTitle(" Unfollow ", for: .normal)
            self.followers.setTitle("Followers: \(user.followedByCount + 1)", for: .normal)
            DataProviders.shared.usersDataProvider.follow(user.id, queue: DispatchQueue.global()) { (userCheck) in
                if userCheck == nil {
                    DataProviders.shared.usersDataProvider.user(with: user.id, queue: DispatchQueue.global()) { (user) in
                        guard let user = user else { return }
                        self.user = user
                    }
                    DispatchQueue.main.async {
                        self.followButtonBlue.setTitle(user.currentUserFollowsThisUser ? " Unfollow " : " Follow ", for: .normal)
                        self.followers.setTitle("Followers: \(user.followedByCount)", for: .normal)
                    }
                }
            }
        }
        
        DataProviders.shared.usersDataProvider.user(with: user.id, queue: DispatchQueue.global()) { (user) in
            guard let user = user else { return }
            self.user = user
        }
    }
}
