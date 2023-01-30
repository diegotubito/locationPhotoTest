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
    
    func setup(image: UIImage) {
        photoImageView.image = image
    }
    
    static var identifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
