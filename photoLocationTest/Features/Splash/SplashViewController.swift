//
//  ViewController.swift
//  photoLocationTest
//
//  Created by Gomez David Diego on 30/01/2023.
//

import UIKit

class SplashViewController: UIViewController {
    var viewModel: SplashViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = SplashViewModel()
        wire()

        viewModel?.loadInitValues()
    }
    
    func wire() {
        viewModel?.onSuccess = { [weak self] in
            self?.animateView()
        }
    }
    
    func animateView() {
        UIView.animate(withDuration: 1) {
            self.view.backgroundColor = .white
        } completion: { _ in
            self.routeToHomeViewController()
        }
    }
    
    func routeToHomeViewController() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard
            let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        else { return }
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: false)
    }
}

