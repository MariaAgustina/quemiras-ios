//
//  MoviesArray.swift
//  quemiras
//
//  Created by Agustina Markosich on 21/07/2020.
//  Copyright © 2020 Agustina. All rights reserved.
//

import UIKit

public struct MoviesArray: Codable {
    let page : Int
    let total_results : Int
    let total_pages : Int
    let results : [Movie]
}
