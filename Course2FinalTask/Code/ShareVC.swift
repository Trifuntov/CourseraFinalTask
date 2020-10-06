//
//  ShareVC.swift
//  Course2FinalTask
//
//  Created by Igor🛠iOSDev on 8/21/20.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class ShareVC: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var textFieldDescriprion: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    let blackView = BlackView()
    var imagePresent: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        blackView.activity(view: view.self)
        DispatchQueue.global(qos: .userInteractive).async {
            if let image = self.imagePresent {
                DispatchQueue.main.async {
                    self.image.image = image
                    self.blackView.stopActivity()
                }
            } else {
                DispatchQueue.main.async {
                    self.blackView.stopActivity()
                    AlertMessage().addAlert(controller: self, navigation: self.navigationController)
                }
            }
        }
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidAppear(true)
        
    }
   
    @IBAction func shareAction(_ sender: UIBarButtonItem) {
        guard let image = imagePresent else { return }
        blackView.activity(view: view.self)
        DataProviders.shared.postsDataProvider.newPost(with: image, description: textFieldDescriprion.text ?? "", queue: DispatchQueue.global(qos: .userInteractive)) { (post) in
            guard let post = post else { return }
            
            DispatchQueue.main.async {
                self.blackView.stopActivity()
               
                self.tabBarController?.selectedIndex = 0
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    

}
