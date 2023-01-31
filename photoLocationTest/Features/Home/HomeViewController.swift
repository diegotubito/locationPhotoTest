//
//  HomeViewController.swift
//  photoLocationTest
//
//  Created by Gomez David Diego on 30/01/2023.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    var viewModel: HomeViewModelProtocol = HomeViewModel()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyListLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super .viewDidLoad()
        setupView()
        setupCollectionView()
        wire()
        viewModel.getPhotos()
        locationManager.requestWhenInUseAuthorization()
    }
        
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    private func setupView() {
        self.view.backgroundColor = .blue
        navigationItem.title = NSLocalizedString("GALERY", comment: "")
        let rightImage = UIImage(systemName: "trash")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightImage,
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(rightButtonItemTapped(_:)))
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCollectionViewCell.nib, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
    }
    
    private func savePhoto(_ image: UIImage,_ latitude: Double,_ longitude: Double) {
        viewModel.savePhoto(image, latitude, longitude)
    }

    private func wire() {
        viewModel.onUpdateList = { [weak self] in 
            guard let self = self else { return }
            self.hideEmptyView()
            self.collectionView.reloadData()
        }
        
        viewModel.onEmptyView = { [weak self] in
            guard let self = self else { return }
            self.showEmptyView()
        }
        
        viewModel.onDeleteSuccess = { [weak self] in
            guard let self = self else { return }
            self.displayRemoveSuccessAlert()
        }
    }
    
    private func hideEmptyView() {
        collectionView.isHidden = false
        emptyListLabel.isHidden = true
        navigationItem.rightBarButtonItem?.isHidden = false
    }
    
    private func showEmptyView() {
        collectionView.isHidden = true
        emptyListLabel.isHidden = false
        navigationItem.rightBarButtonItem?.isHidden = true
    }
    
    private func routeToDetailViewController(photo: Photo) {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        guard
            let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        else { return }
        detailViewController.photo = photo
        detailViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    @IBAction func openCameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func rightButtonItemTapped(_ obj: UIBarButtonItem) {
        displayRemoveAlert()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getList().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell
        cell?.setup(image: viewModel.getList()[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let list = viewModel.getList()
        routeToDetailViewController(photo: list[indexPath.row])
    }
}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        else { return }
        DispatchQueue.main.async {
            let latitude = self.locationManager.location?.coordinate.latitude ?? 0.0
            let longitude = self.locationManager.location?.coordinate.longitude ?? 0.0
            self.savePhoto(image, latitude, longitude)
            self.dismiss(animated: false)
        }
    }
}
