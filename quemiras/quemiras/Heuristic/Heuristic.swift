//
//  Heuristic.swift
//  quemiras
//
//  Created by Agustina Markosich on 25/07/2020.
//  Copyright © 2020 Agustina. All rights reserved.
//

import UIKit

protocol HeuristicMovieDelegate {
    func heuristicMovieFound(movie : Movie)
}
class Heuristic: NSObject {
    
    var userMoviePreferences : UserMoviePreferences = UserMoviePreferences()
    var delegate : HeuristicMovieDelegate?
    
    public func getMovieRecommendation(){
        let service : MovieDiscoverService = MovieDiscoverService()
        service.delegate = self
        service.discoverMovies(userPreferences:self.userMoviePreferences)
    }
    
    
}

extension Heuristic : MovieDiscoverProtocol{
    func movieDiscoverSucceded(movies: MoviesArray){
        let filteredArray = movies.results.filter{
            !userMoviePreferences.seenMovies.contains($0.id)
        }

        if(filteredArray.count > 0){
            let movie: Movie = filteredArray[0]
            self.delegate?.heuristicMovieFound(movie: movie)
        }
        
    }
    
    func movieDiscoverFailed(error: Error){
        //TODO
    }
}
