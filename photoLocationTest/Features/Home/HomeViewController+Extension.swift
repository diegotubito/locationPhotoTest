//
//  HomeViewController+Extension.swift
//  photoLocationTest
//
//  Created by Gomez David Diego on 31/01/2023.
//

import UIKit

extension HomeViewController {
    func displayRemoveAlert() {
        // Declare Alert message
        let dialogMessage = UIAlertController(title: NSLocalizedString("DELETE_WARNING_TITLE", comment: ""),
                                              message: NSLocalizedString("DELETE_WARNING_MESSAGE", comment: ""),
                                              preferredStyle: .alert)
        
        let ok = UIAlertAction(title: NSLocalizedString("DELETE_WARNING_CONFIRM_BUTTON", comment: ""),
                               style: .default,
                               handler: { (action) -> Void in
            self.deleteRecord()
        })
        
        let cancel = UIAlertAction(title: NSLocalizedString("DELETE_WARNING_CANCEL_BUTTON", comment: ""),
                                   style: .cancel) { (action) -> Void in }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func deleteRecord() {
        viewModel.deletePhotos()
    }
    
    func displayRemoveSuccessAlert() {
        let dialogMessage = UIAlertController(title: NSLocalizedString("DELETE_SUCCESS_TITLE", comment: ""),
                                              message: NSLocalizedString("DELETE_SUCCESS_MESSAGE", comment: ""),
                                              preferredStyle: .alert)
        
        let ok = UIAlertAction(title: NSLocalizedString("DELETE_SUCCESS_CONFIRM_BUTTON", comment: ""), style: .default, handler: { (action) -> Void in })
        
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}
