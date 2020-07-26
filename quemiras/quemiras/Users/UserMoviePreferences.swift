//
//  UserMoviePreferences.swift
//  quemiras
//
//  Created by Agustina Markosich on 22/07/2020.
//  Copyright © 2020 Agustina. All rights reserved.
//

import UIKit

class UserMoviePreferences {
    
    //TODO
    //region
    //sort_by
    //with_companies
    
    //EN DUDA
    //directores,actores
    
    var movieGenres : MovieGenres = MovieGenres(genres: [])
    var fromReleaseDate : String?
    var untilReleaseDate : String?
    var mostPopular : Bool = true
    var runtime : String = "90"

    var seenMovies : Array<Int> = []
}
