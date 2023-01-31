//
//  HomeViewController.swift
//  photoLocationTest
//
//  Created by Gomez David Diego on 30/01/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModelProtocol = HomeViewModel()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        setupCollectionView()
        wire()
        viewModel.getPhotos()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCollectionViewCell.nib, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
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
    
    private func savePhoto(image: UIImage) {
        viewModel.savePhoto(image: image)
    }

    private func wire() {
        viewModel.onUpdateList = { [weak self] in 
            guard let self = self else { return }
           
            self.collectionView.reloadData()
        }
    }
    
    func routeToDetailViewController(photo: Photo) {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        guard
            let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        else { return }
        
        detailViewController.photo = photo
        detailViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(detailViewController, animated: true)
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
            self.savePhoto(image: image)
            self.dismiss(animated: false)
        }
    }
}
