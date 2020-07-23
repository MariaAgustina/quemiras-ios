//
//  MovieGenre.swift
//  quemiras
//
//  Created by Agustina Markosich on 22/07/2020.
//  Copyright © 2020 Agustina. All rights reserved.
//

import UIKit

public struct MovieGenre : Codable {
    let id : Int
    let name : String
    var isSelected : Bool?
}

public struct MovieGenres: Codable {
    let genres: Array<MovieGenre>
}
