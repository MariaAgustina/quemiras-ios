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
    var runtimeOffset : Int = 0
    var monthOffset : Int = 0

    var seenMovies : Array<Int> = []
    
    func getUserMovieRuntimeLte() -> Int{
        return Int(runtime)!
    }
    
    func getUserMovieRuntimeGte() -> Int{
        return Int(runtime)!
    }
    
    func getUntilRelaseDate() -> String{
        if let untilDate = self.untilReleaseDate{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let theDate  = formatter.date(from:untilDate)!
            let date = Calendar.current.date(byAdding: .month, value: monthOffset, to: theDate)
            return formatter.string(from: date!)
        }

        return ""
    }
    
    func getFromReleaseDate() -> String{
        if let fromDate = self.fromReleaseDate{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let theDate  = formatter.date(from:fromDate)!
            let date = Calendar.current.date(byAdding: .month, value: -monthOffset, to: theDate)
            return formatter.string(from: date!)
        }

        return ""
    }    
    
}
