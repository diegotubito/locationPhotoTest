//
//  CoreDataPhotoTest.swift
//  photoLocationTestTests
//
//  Created by Gomez David Diego on 31/01/2023.
//

import XCTest
import CoreData
@testable import photoLocationTest

final class CoreDataPhotoTest: XCTestCase {

    func testFetchPhotos() {
        //Given
        let context = TestCoreDataStack().persistentContainer.newBackgroundContext()
       
        let newPhoto = Photo(context: context)
        newPhoto.setValue(Date(), forKey: #keyPath(Photo.createdAt))
        newPhoto.setValue("thumbnail image string", forKey: #keyPath(Photo.thumbnail))
        newPhoto.setValue( Data(), forKey: #keyPath(Photo.image))
        newPhoto.setValue(35, forKey: #keyPath(Photo.latitude))
        newPhoto.setValue(-36, forKey: #keyPath(Photo.longitude))
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in
            return true
        }
       
        try! context.save()
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
        
        //When
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let result = try? context.fetch(fetchRequest)
        let finalProduct1 = result?.first
        
        //Then
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(finalProduct1?.latitude, newPhoto.latitude)
        XCTAssertEqual(finalProduct1?.longitude, newPhoto.longitude)
    }
}
