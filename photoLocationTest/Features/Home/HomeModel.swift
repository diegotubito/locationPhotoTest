//
//  HomeModel.swift
//  photoLocationTest
//
//  Created by Gomez David Diego on 30/01/2023.
//

import UIKit

struct HomeModel {
    var image: UIImage
    var list: [UIImage] = []
    
    init(image: UIImage) {
        self.image = image
    }
}
