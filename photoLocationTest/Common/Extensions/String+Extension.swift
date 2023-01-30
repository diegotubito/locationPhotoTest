//
//  String+Extension.swift
//  photoLocationTest
//
//  Created by Gomez David Diego on 30/01/2023.
//

import UIKit

extension String {
    var convertToImage: UIImage? {
        if let decodedData = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0) ) {
            if let decodedimage = UIImage(data: decodedData as Data) {
                return decodedimage
            }
        }
        return nil
        
    }
}
