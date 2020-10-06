//
//  BlackView.swift
//  Course2FinalTask
//
//  Created by Igor🛠iOSDev on 9/2/20.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

class BlackView {
    
    private var viewBlack: UIView?
    
    func activity(view: UIView) {
        self.viewBlack = UIView(frame: view.bounds)
        viewBlack?.backgroundColor = .black
        viewBlack?.alpha = 0.7
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = viewBlack!.center
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        viewBlack?.addSubview(activityIndicator)
        view.addSubview(viewBlack!)
    }
    
    func stopActivity() {
        viewBlack?.removeFromSuperview()
    }
    
}
