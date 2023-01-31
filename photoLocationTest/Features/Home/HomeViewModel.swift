//
//  HomeViewModel.swift
//  photoLocationTest
//
//  Created by Gomez David Diego on 30/01/2023.
//

import UIKit
import CoreData

protocol HomeViewModelProtocol {
    func deletePhotos()
    func getPhotos()
    func savePhoto(_ image: UIImage,_ latitude: Double,_ longitude: Double)
    func getList() -> [Photo]
    
    var onUpdateList: (() -> Void)? { get set }
    var onEmptyView: (() -> Void)? { get set }
    var onDeleteSuccess: (() -> Void)? { get set }
}

class HomeViewModel: HomeViewModelProtocol {
    var model: HomeModel
    var onUpdateList: (() -> Void)?
    var onEmptyView: (() -> Void)?
    var onDeleteSuccess: (() -> Void)?
    
    init() {
        self.model = HomeModel()
    }
    
    private func getThumbnailImageString(image: UIImage) -> String? {
        // Thumbnail images are going to be random sizes, among these values.
        let numbers = [0.05, 0.1, 0.15, 0.2]
        
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
        
    func savePhoto(_ image: UIImage,_ latitude: Double,_ longitude: Double) {
        guard let thumbnail = getThumbnailImageString(image: image),
              let imageData = getImageData(image: image)
        else { return }
        
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        let newPhoto = Photo(context: managedContext)
        newPhoto.setValue(Date(), forKey: #keyPath(Photo.createdAt))
        newPhoto.setValue(thumbnail, forKey: #keyPath(Photo.thumbnail))
        newPhoto.setValue( NSData(data: imageData), forKey: #keyPath(Photo.image))
        newPhoto.setValue(latitude, forKey: #keyPath(Photo.latitude))
        newPhoto.setValue(longitude, forKey: #keyPath(Photo.longitude))

        self.model.list.append(newPhoto)
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        
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
            
            results.isEmpty ? onEmptyView?() : onUpdateList?()
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    func deletePhotos() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: "Photo")
     
        let deleteRequest = NSBatchDeleteRequest(
            fetchRequest: fetchRequest
        )
        
        deleteRequest.resultType = .resultTypeObjectIDs
        
        let context = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        
        do {
            try context.execute(deleteRequest)
            self.model.list.removeAll()
            DispatchQueue.main.async {
                self.onEmptyView?()
                self.onDeleteSuccess?()
            }
        } catch {
            print("Delete error: \(error)")
        }
    }
    
    func getList() -> [Photo] {
        model.list
    }
}
