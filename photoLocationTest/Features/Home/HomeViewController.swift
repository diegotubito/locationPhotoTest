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
    
    private func imageSize(image: UIImage) -> Int {
        guard let imageJPEGData = image.jpegData(compressionQuality: 1) else { return -1 }
        let imgData = NSData(data: imageJPEGData)
        
        return imgData.count
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

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getList().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell
        cell?.setup(image: viewModel.getList()[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        else { return }
        
        DispatchQueue.main.async {
            self.savePhoto(image: image.scalePreservingAspectRatio(targetSize: CGSize(width: 100, height: 100)))
            self.dismiss(animated: false)
        }
    }
}
