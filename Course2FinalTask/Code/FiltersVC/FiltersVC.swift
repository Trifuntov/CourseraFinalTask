//
//  FiltersVC.swift
//  Course2FinalTask
//
//  Created by Igor🛠iOSDev on 8/21/20.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

class FiltersVC: UIViewController {
    
    let blackView = BlackView()
    var litleImage: UIImage?
    var tempImage: UIImage?
    var image: UIImage?
    let filters = ["Original", "Process", "ColorInvert", "SepiaTone", "EffectNoir", "Pixellate", "GaussianBlur"]
    
    let imageFilters = ImageFilters()
    
    @IBOutlet weak var bigImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        blackView.activity(view: view.self)
        loadData()
    }
    
    func loadData() {
        guard let image = self.image else { return }
        bigImage.image = image
        tempImage = image
        blackView.stopActivity()
    }
    
}

extension FiltersVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FilterCell
        
        let name = filters[indexPath.item]
        guard let image = litleImage else { return cell }
        
        switch name {
        case "Original":
            cell.image.image = litleImage
        case "Process":
            DispatchQueue.global().async {
                let image = self.imageFilters.applyProcess(originalImage: image)
                DispatchQueue.main.async {
                    cell.image.image = image
                }
            }
        case "ColorInvert":
            DispatchQueue.global().async {
                let image = self.imageFilters.applyInvert(originalImage: image)
                DispatchQueue.main.async {
                    cell.image.image = image
                }
            }
            
        case "SepiaTone":
            DispatchQueue.global().async {
                let image = self.imageFilters.applySepia(originalImage: image)
                DispatchQueue.main.async {
                    cell.image.image = image
                }
            }
            
        case "EffectNoir":
            DispatchQueue.global().async {
                let image = self.imageFilters.applyNoir(originalImage: image)
                DispatchQueue.main.async {
                    cell.image.image = image
                }
            }
        case "Pixellate":
            DispatchQueue.global().async {
                let image = self.imageFilters.applyPixellate(originalImage: image)
                DispatchQueue.main.async {
                    cell.image.image = image
                }
            }
        case "GaussianBlur":
            DispatchQueue.global().async {
                let image = self.imageFilters.applyGaussianBlur(originalImage: image)
                DispatchQueue.main.async {
                    cell.image.image = image
                }
            }
        default:
            break
        }
        
        cell.filterName.text = name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        blackView.activity(view: view.self)
        let nameFilter = filters[indexPath.item]
        DispatchQueue.global(qos: .userInitiated).async {
            
            guard let image = self.image else { return }
            switch nameFilter {
            case "Original":
                 self.tempImage = image
            case "Process":
                self.tempImage = self.imageFilters.applyProcess(originalImage: image)
            case "ColorInvert":
                self.tempImage = self.imageFilters.applyInvert(originalImage: image)
            case "SepiaTone":
                self.tempImage = self.imageFilters.applySepia(originalImage: image)
            case "EffectNoir":
                self.tempImage = self.imageFilters.applyNoir(originalImage: image)
            case "Pixellate":
                self.tempImage = self.imageFilters.applyPixellate(originalImage: image)
            case "GaussianBlur":
                self.tempImage = self.imageFilters.applyGaussianBlur(originalImage: image)
            default:
                break
            }
            
            DispatchQueue.main.async {
                self.blackView.stopActivity()
                self.bigImage.image = self.tempImage
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segue") {
            let destination = segue.destination as! ShareVC
            destination.imagePresent = tempImage
        }
    }
}


