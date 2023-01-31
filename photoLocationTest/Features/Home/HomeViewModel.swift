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
    
    private func getThumbnail(image: UIImage) -> String? {
        let numbers = [0.05, 0.1, 0.15, 0.2]  // Thumbnail images are going to be random, among these values.
        let shuffledNumbers = (numbers as NSArray).shuffled() as! [CGFloat]
        guard let widthPorcentage = shuffledNumbers.randomElement(),
              let heightPorcentage = shuffledNumbers.randomElement() else { return nil }
        
        let screenWidth = UIScreen.main.bounds.size.width
        let width = screenWidth * widthPorcentage
        let height = screenWidth * heightPorcentage
        let thumbnailImage = image.scalePreservingAspectRatio(targetSize: CGSize(width: width, height: height))
        return thumbnailImage.convertToBase64
    }
    
    private func getImageData(image: UIImage) -> Data? {
        image.jpegData(compressionQuality: 1)
    }
        
    func savePhoto(image: UIImage) {
        guard let thumbnail = getThumbnail(image: image),
              let imageData = getImageData(image: image)
        else { return }
        
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        let newPhoto = Photo(context: managedContext)
        newPhoto.setValue(Date(), forKey: #keyPath(Photo.createdAt))
        newPhoto.setValue(thumbnail, forKey: #keyPath(Photo.thumbnail))
        newPhoto.setValue( NSData(data: imageData), forKey: #keyPath(Photo.image))
        
        self.model.list.insert(newPhoto, at: 0)
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext() // Save changes in CoreData
        
        DispatchQueue.main.async {
            self.onUpdateList?()
        }
    }
    
    func getPhotos() {
        let photoFetch: NSFetchRequest<Photo> = Photo.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(Photo.createdAt), ascending: false)
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
