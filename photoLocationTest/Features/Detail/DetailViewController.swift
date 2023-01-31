//
//  DetailViewController.swift
//  photoLocationTest
//
//  Created by Gomez David Diego on 30/01/2023.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var photo: Photo?
    
    override func viewDidLoad() {
        super .viewDidLoad()
        updateData()
    }
    
    func updateData() {
        guard let photo = photo,
              let imageData = photo.image,
              let image = UIImage(data: imageData) else { return }
        imageView.image = image
    }
}
