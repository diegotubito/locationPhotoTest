//
//  HomeViewModel.swift
//  photoLocationTest
//
//  Created by Gomez David Diego on 30/01/2023.
//

import UIKit
import CoreData

protocol HomeViewModelProtocol {
    func getPhotos()
    func savePhoto(image: UIImage)
    func getList() -> [Photo]
    
    var onUpdateList: (() -> Void)? { get set }
}

class HomeViewModel: HomeViewModelProtocol {
    var model: HomeModel
    var onUpdateList: (() -> Void)?
    
    init() {
        self.model = HomeModel()
    }
        
    func savePhoto(image: UIImage) {
        let thumbnailImage = image.scalePreservingAspectRatio(targetSize: CGSize(width: 100, height: 100))
        
        guard let thumbnail = thumbnailImage.convertToBase64,
              let imageData = image.jpegData(compressionQuality: 1)
        else { return }
        
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        let newPhoto = Photo(context: managedContext)
        newPhoto.setValue(Date(), forKey: #keyPath(Photo.createdAt))
        newPhoto.setValue(thumbnail, forKey: #keyPath(Photo.thumbnail))
        newPhoto.setValue(imageData, forKey: #keyPath(Photo.image))
        
        self.model.list.insert(newPhoto, at: 0)
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext() // Save changes in CoreData
        
        DispatchQueue.main.async {
            self.onUpdateList?()
        }
    }
    
    func getPhotos() {
        let photoFetch: NSFetchRequest<Photo> = Photo.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(Photo.createdAt), ascending: true)
        photoFetch.sortDescriptors = [sortByDate]
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(photoFetch)
            model.list = results
            onUpdateList?()
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    func getList() -> [Photo] {
        model.list
    }
}
