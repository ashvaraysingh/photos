//
//  Photo.swift
//  Photos
//
//  Created by Ashvarya Singh on 29/08/20.
//  Copyright © 2020 Ashvaray. All rights reserved.
//

import Foundation

/*
 {"format":"jpeg","width":5616,"height":3744,"filename":"0.jpeg","id":0,"author":"Alejandro Escamilla","author_url":"https://unsplash.com/photos/yC-Yzbqy7PY","post_url":"https://unsplash.com/photos/yC-Yzbqy7PY"}
 */
struct Photo: Decodable {
    let id: String
    let width: Int
    let height: Int
    let author: String
    
    private enum CodingKeys: String, CodingKey {
        case id, author, width, height
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        author = try container.decode(String.self, forKey: .author)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
    }
}

