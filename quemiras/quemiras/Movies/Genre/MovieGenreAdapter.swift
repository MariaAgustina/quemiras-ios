//
//  MovieGenreAdapter.swift
//  quemiras
//
//  Created by Agustina Markosich on 22/07/2020.
//  Copyright © 2020 Agustina. All rights reserved.
//

import UIKit

class MovieGenreAdapter {
    static func getMovieGenresParams(selectedGenres: Array<MovieGenre>) -> String{
        var genresString : String = ""
        for selectedGenre in selectedGenres{
            genresString = genresString + String(selectedGenre.id) + ","
        }
        return genresString
    }
}
