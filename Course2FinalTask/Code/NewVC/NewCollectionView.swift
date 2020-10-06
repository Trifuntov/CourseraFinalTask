//
//  NewCollectionView.swift
//  Course2FinalTask
//
//  Created by Igor🛠iOSDev on 8/21/20.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class NewCollectionView: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private var user: User?
   private var photos = [UIImage]()
    let blackView = BlackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        blackView.activity(view: view.self)
        collectionView.reloadData()
        navigationItem.title = "New post"
        loadData()
    }


    
    func loadData() {
        let queue = DispatchQueue(label: "Queue", qos: .userInteractive, attributes: .concurrent)
        let workItem = DispatchWorkItem {
            self.user = UserIDSet.shared.currentUser
            self.photos = DataProviders.shared.photoProvider.photos()
        }
        
        workItem.notify(queue: DispatchQueue.main) {
            self.collectionView.reloadData()
            self.blackView.stopActivity()
        }
        
        queue.async(execute: workItem)
       
       
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! NewVCCell

        cell.postImage.image = photos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
   }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segue") {
            let destination = segue.destination as! FiltersVC
            let cell = sender as! NewVCCell
            let indexPathCollection = collectionView.indexPath(for: cell)
            guard let indexPath = indexPathCollection else { return }
            destination.image = photos[indexPath.item]
            destination.litleImage = DataProviders.shared.photoProvider.thumbnailPhotos()[indexPath.item]
        }
    }
    
}

