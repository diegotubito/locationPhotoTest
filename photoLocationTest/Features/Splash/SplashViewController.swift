//
//  ViewController.swift
//  photoLocationTest
//
//  Created by Gomez David Diego on 30/01/2023.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        animateView {
            // When animation finishes we navigate to Home View Controller.
            self.routeToHomeViewController()
        }
    }
    
    func animateView(completion: @escaping () -> Void) {
        self.view.backgroundColor = .black
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseOut) {
            self.view.backgroundColor = .blue
            self.welcomeLabel.transform = CGAffineTransform(scaleX: 4, y: 4)
            self.welcomeLabel.alpha = 0
        } completion: { _ in
            completion()
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

