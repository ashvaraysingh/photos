//
//  PhotosViewController.swift
//  Photos
//
//  Created by Ashvarya Singh on 29/08/20.
//  Copyright © 2020 Ashvaray. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PhotoCell"

class PhotosViewController: UICollectionViewController {
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    // MARK: - Private Properties
    private let viewModel = PhotosViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
        setUpBindingAndGetPhotos()
    }
    
    // MARK: - Orientation Change method
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.cache.removeAll()
            layout.contentHeight = 0
            if size.width < size.height {
                layout.numberOfColumns = 2
            } else {
                layout.numberOfColumns = 3
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.value.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PhotoCell
        let photCellViewModel = viewModel.photos.value[indexPath.item]
        cell.configureCell(cellViewModel: photCellViewModel)
        return cell
    }
        
    // MARK: - Helper Functions
    private func setUpBindingAndGetPhotos() {
        viewModel.errorMessage.bind { (message) in
            debugPrint(message ?? "")
        }
        viewModel.isBusy.bind { [unowned self] isBusy in
            if isBusy {
                self.loader.startAnimating()
            } else {
                self.loader.stopAnimating()
            }
        }
        viewModel.photos.bind { [unowned self] photos in
            if photos.count > 0 {
                self.collectionView.reloadData()
            }
        }
        viewModel.getPhotos()
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
}

extension PhotosViewController: PinterestLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        let photCellViewModel = viewModel.photos.value[indexPath.item]
        let insets = collectionView.contentInset
        let width = collectionView.bounds.width - (insets.left + insets.right + 10)
        let height = (width / 2) * photCellViewModel.heightToWidthRatio
        return height
    }
}
