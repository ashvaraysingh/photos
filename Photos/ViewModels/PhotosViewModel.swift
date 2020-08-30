//
//  PhotosViewModel.swift
//  Photos
//
//  Created by Ashvarya Singh on 29/08/20.
//  Copyright © 2020 Ashvaray. All rights reserved.
//

import Foundation

class PhotosViewModel {
    private let apiClient: APIClient
    var isBusy: Bindable<Bool> = Bindable(false)
    var photos: Bindable<[PhotoCellViewModel]> = Bindable([])
    var errorMessage: Bindable<String?> = Bindable(nil)
    
    init(client: APIClient? = nil) {
        apiClient = client ?? APIClient.shared
    }
    
    func getPhotos() {
        isBusy.value = true
        apiClient.dataTask(of: Photo.self, from: PhotosAPI.getPhotosList) { result in
            self.isBusy.value = false
            switch result {
            case .success(let photos):
                self.photos.value = photos.map({ PhotoCellViewModel(photo: $0) })
                Log.info(photos.description)
            case .failure(let error):
                if error is DataError {
                    Log.error(error.localizedDescription)
                    self.errorMessage.value = error.localizedDescription
                } else {
                    Log.error(error.localizedDescription)
                }
            }
        }
    }
}
