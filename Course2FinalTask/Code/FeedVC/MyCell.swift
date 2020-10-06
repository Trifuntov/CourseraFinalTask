//
//  MyCell.swift
//  Course2FinalTask
//
//  Created by Igor Trifuntov on 28.06.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

// Протокол для делегата функций в FeedVC
protocol MyCellDelegate: NSObjectProtocol{
    func likeButton(cell: UITableViewCell)
    func doubleTapLike(cell: UITableViewCell)
    func userBtn(cell: UITableViewCell)
}

class MyCell: UITableViewCell {
    
    weak var delegate: MyCellDelegate?
    
    private var likeBool = false
    private var likeCount: Int = 0
    
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var buttonLike: UIButton!
    @IBOutlet weak var bigLikeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bigLikeImage.alpha = 0
        buttonLike.setImage(UIImage(named: "like"), for: .normal)
        setActionCell()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(post: Post) {
        likeCount = post.likedByCount
        likeBool = post.currentUserLikesThisPost
        avatar.image = post.authorAvatar
        nameUser.text = post.authorUsername
        date.text = "\(Date().formatDate(date: post.createdTime))"
        imagePost.image = post.image
        likeLabel.text = "Like: " + "\(likeCount)"
        descriptionLabel.text = post.description
        buttonLike.tintColor = post.currentUserLikesThisPost ? UIView().tintColor : .lightGray
    }
    
    func setActionCell() {
        // TapGesture
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(bigLikeTap))
        recognizer.numberOfTapsRequired = 2
        imagePost.isUserInteractionEnabled = true
        imagePost.addGestureRecognizer(recognizer)
        // LikeBtn
        buttonLike.addTarget(self, action: #selector(likeButton), for: .touchUpInside)
        avatarButton.addTarget(self, action: #selector(userAvatar), for: .touchUpInside)
    }
    
    @objc func likeButton() {
        buttonLike.tintColor = (buttonLike.tintColor == .lightGray) ? UIView().tintColor : .lightGray
        if likeBool {
            likeLabel.text = "Like: " + "\(likeCount - 1)"
         
        } else {
            likeLabel.text = "Like: " + "\(likeCount + 1)"
           
        }
        delegate?.likeButton(cell: self)
    }
    
    @objc func bigLikeTap() {
        guard !likeBool else { return }
        // CATransaction используется для того чтоб срабатывала анимация, а только после этого уже обновлялалсь ячейка, то есть сначала срабатывает анимация, а потом уже отрабатывает complition который передает делегат в feedVC
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.delegate?.doubleTapLike(cell: self)
        })
        //Блок анимации
        let animation = CAKeyframeAnimation(keyPath: "opacity")
        animation.values = [0, 1, 1, 0]
        animation.keyTimes = [0, 0.2, 0.5, 1]
        animation.duration = 0.6
        animation.calculationMode = CAAnimationCalculationMode.discrete
        bigLikeImage.layer.add(animation, forKey: nil)
        CATransaction.commit()
        buttonLike.tintColor = UIView().tintColor
        likeLabel.text = "Like: " + "\(likeCount + 1)"
    }
    
    @objc func userAvatar() {
        delegate?.userBtn(cell: self)
    }
}

// MARK: - Date Formatter
extension Date {
    func formatDate(date: Date) -> String{
        let formatDay = DateFormatter()
        let formatTime = DateFormatter()
        let dateForData = Calendar.current.dateComponents([.day, .month, .year], from: date)
        let dateCurrent = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        if dateForData == dateCurrent {
            formatTime.dateFormat = "h:mm:ss a"
            let date = "Today at " + formatTime.string(from: date as Date)
            return date
        } else {
            formatDay.dateFormat = "MMM d, YYYY"
            formatTime.dateFormat = "h:mm:ss a"
            let date = formatDay.string(from: date as Date) + " at " + formatTime.string(from: date as Date)
            return date
        }
    }
}



