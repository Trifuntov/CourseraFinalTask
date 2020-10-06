//
//  Alert.swift
//  Course2FinalTask
//
//  Created by Igor🛠iOSDev on 9/3/20.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

class AlertMessage {
    
    func addAlert(controller: UIViewController, navigation: UINavigationController?){
        let alert = UIAlertController(title: "Unknown error", message: "Please, try again later.", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
            navigation?.popToRootViewController(animated: true)
               }))
        controller.present(alert, animated: true, completion: nil)
    }
}

