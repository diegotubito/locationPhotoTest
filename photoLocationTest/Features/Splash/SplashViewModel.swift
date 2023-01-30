//
//  SplashViewModel.swift
//  photoLocationTest
//
//  Created by Gomez David Diego on 30/01/2023.
//

import Foundation

protocol SplashViewModelProtocol {
    func loadInitValues()
    
    var onSuccess: (() -> Void )? { get set }
}

class SplashViewModel: SplashViewModelProtocol {
    
    var onSuccess: (() -> Void)?
    
    func loadInitValues() {
        onSuccess?()
    }
}
