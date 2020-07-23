//
//  Movie.swift
//  quemiras
//
//  Created by Agustina Markosich on 21/07/2020.
//  Copyright © 2020 Agustina. All rights reserved.
//
import UIKit

public struct Movie: Codable {
    
    let poster_path : String?
    let adult : Bool
    let overview : String
    let release_date : String
    let id : Int
    let genre_ids : Array<Int>
    let original_title : String
    let original_language : String
    let title : String
    let backdrop_path : String?
    let popularity : Float
    let vote_count : Int
    let video : Bool
    let vote_average : Float
    
}
