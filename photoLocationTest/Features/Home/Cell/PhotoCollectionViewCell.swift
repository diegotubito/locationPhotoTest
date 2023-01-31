//
//  PhotoCollectionViewCell.swift
//  photoLocationTest
//
//  Created by Gomez David Diego on 30/01/2023.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(image: Photo) {
//        photoImageView.image = image.thumbnail?.convertToImage
        guard let imageData = image.image else { return }
        photoImageView.image = UIImage(data: imageData)
    }
    
    static var identifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
