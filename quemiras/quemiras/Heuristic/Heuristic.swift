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
    func heuristicMovieNotFound()
}
class Heuristic: NSObject {
    
    var userMoviePreferences : UserMoviePreferences = UserMoviePreferences()
    var delegate : HeuristicMovieDelegate?
    var service : MovieDiscoverService = MovieDiscoverService()
    var retryTimes : Int = 0
    
    public func getMovieRecommendation(){
        service = MovieDiscoverService()
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
            self.retryTimes = 0
            let movie: Movie = filteredArray[0]
            service.getMovie(movie: movie)
        }else{
            print("Movies not found!")
            if (retryTimes <= 10){
                retryTimes+=1
                self.userMoviePreferences.runtimeOffset += 5
                self.getMovieRecommendation()
            }else{
                self.delegate?.heuristicMovieNotFound()
                print("NO RESULTS FOUND :(")
            }

        }
        
    }
    
    func movieDetailsSucceded(movie: Movie){
        self.delegate?.heuristicMovieFound(movie: movie)
    }
    
    func movieDiscoverFailed(error: Error){
        //TODO
    }
}
