//
//  ImageFilters.swift
//  Course2FinalTask
//
//  Created by Igor🛠iOSDev on 9/3/20.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

class ImageFilters {
        
        let context = CIContext()
        
        public func applyGaussianBlur(originalImage: UIImage) -> UIImage? {
            guard let ciimage = CIImage(image: originalImage) else {
                return nil
            }
            return applyFilter(name: "CIGaussianBlur", params: [kCIInputImageKey: ciimage, kCIInputRadiusKey: originalImage.size.width / 50])
        }
        
        public func applyProcess(originalImage: UIImage) -> UIImage? {
               guard let ciimage = CIImage(image: originalImage) else {
                   return nil
               }
               return applyFilter(name: "CIPhotoEffectProcess", params: [kCIInputImageKey: ciimage])
           }
    
        public func applyNoir(originalImage: UIImage) -> UIImage? {
            guard let ciimage = CIImage(image: originalImage) else {
                return nil
            }
            return applyFilter(name: "CIPhotoEffectNoir", params: [kCIInputImageKey: ciimage])
        }
        
        public func applyInvert(originalImage: UIImage) -> UIImage? {
            guard let ciimage = CIImage(image: originalImage) else {
                return nil
            }
            return applyFilter(name: "CIColorInvert", params: [kCIInputImageKey: ciimage])
        }
        
        public func applySepia(originalImage: UIImage) -> UIImage? {
            guard let ciimage = CIImage(image: originalImage) else {
                return nil
            }
            return applyFilter(name: "CISepiaTone", params: [kCIInputImageKey: ciimage])
        }
        
        public func applyPixellate(originalImage: UIImage) -> UIImage? {
            guard let ciimage = CIImage(image: originalImage) else {
                return nil
            }
            return applyFilter(name: "CIPixellate", params: [kCIInputImageKey: ciimage])
        }
        
        private func applyFilter(name: String, params: [String: Any]) -> UIImage? {
            
            guard let filter = CIFilter(name: name, parameters: params),
                let outputImage = filter.outputImage,
                let cgiimage = context.createCGImage(outputImage, from: outputImage.extent) else {
                    return nil
            }
            return UIImage(cgImage: cgiimage)
        }
    }


