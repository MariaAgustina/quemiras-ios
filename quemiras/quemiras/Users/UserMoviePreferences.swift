//
//  UserMoviePreferences.swift
//  quemiras
//
//  Created by Agustina Markosich on 22/07/2020.
//  Copyright © 2020 Agustina. All rights reserved.
//

import UIKit

class UserMoviePreferences {
    
    //HECHAS
    //1 with_genres
    //release_date.lte 2
    //release_date.gte 3
    // mas votada 4
    //duracion 5
    
    //TODO
    //region
    //sort_by
    //with_companies
    //runtime.lte
    //runtime.gte
    
    //EN DUDA
    //directores,actores
    //popularidad: con el sort by las ordenamos por popularidad o menos popular
    
    //1
    var movieGenres : MovieGenres = MovieGenres(genres: [])
    var fromReleaseDate : String?
    var untilReleaseDate : String?
    var mostPopular : Bool = true
    var runtime : String = "90"

}
