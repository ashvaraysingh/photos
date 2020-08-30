//
//  PhotosTests.swift
//  PhotosTests
//
//  Created by Ashvarya Singh on 30/08/20.
//  Copyright © 2020 Ashvaray. All rights reserved.
//

import XCTest
@testable import Photos

class PhotosTests: XCTestCase {
    var photosViewModel: PhotosViewModel!
    
    override func setUp() {
        // let session = URLSession.shared  // For testing from api
           let session = MockSession()      // For testing from mock response 
           let client = APIClient(session: session)
           photosViewModel = PhotosViewModel(client: client)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPhotosAPISuccessResponse() {
        let expectation = self.expectation(description: "No response recevice from photo list API.")
        
        photosViewModel.errorMessage.bind { (message) in
            XCTAssert(message == nil, message!)
        }
        photosViewModel.photos.bind { (photos) in
            if photos.count > 0 {
                expectation.fulfill()
            }
        }
        photosViewModel.getPhotos()
        self.waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testPhotoListAPIResultCount() {
        let expectation = self.expectation(description: "Invalid number of photos returns by photo list API.")
        
        photosViewModel.errorMessage.bind { (message) in
            XCTAssert(message == nil, message!)
        }
        photosViewModel.photos.bind { (photos) in
            if photos.count > 10 {
                expectation.fulfill()
            }
        }
        photosViewModel.getPhotos()
        self.waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testPhotoAPIObject() {
        let expectation = self.expectation(description: "Invalid number of contact returns by contact list API.")
        photosViewModel.errorMessage.bind { (message) in
            XCTAssert(message == nil, message!)
        }
        photosViewModel.photos.bind { (photos) in
            if let photoCellViewModel = photos.first {
                XCTAssert(photoCellViewModel.authorName != "", "Author name is blank")
                XCTAssert(photoCellViewModel.imageUrl != nil, "Image is nil")
                expectation.fulfill()
            }
        }
        photosViewModel.getPhotos()
        self.waitForExpectations(timeout: 10.0, handler: nil)
    }
    

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
