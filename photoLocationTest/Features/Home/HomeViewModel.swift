//
//  HomeViewModel.swift
//  photoLocationTest
//
//  Created by Gomez David Diego on 30/01/2023.
//

import UIKit

protocol HomeViewModelProtocol {
    func setImage(image: UIImage)
    func appendItem(image: UIImage)
    func loadPhotos()
    func savePhoto(image: UIImage)
    func getList() -> [UIImage]
    
    var onUpdateList: (() -> Void)? { get set }
}

class HomeViewModel: HomeViewModelProtocol {
    var model: HomeModel
    var onUpdateList: (() -> Void)?
    
    init() {
        self.model = HomeModel(image: UIImage())
    }
    
    func setImage(image: UIImage) {
        model = HomeModel(image: image)
    }
    
    func appendItem(image: UIImage) {
        model.list.append(image)
    }
    
    func loadPhotos() {
        // from Core Data
        // mock data
        model.list = [UIImage(systemName: "pencil")!]
        
        onUpdateList?()
    }
    
    func savePhoto(image: UIImage) {
        // save to core data
        
        //mock data
        model.list.append(image)
        onUpdateList?()
    }
    
    func getList() -> [UIImage] {
        model.list
    }
}
