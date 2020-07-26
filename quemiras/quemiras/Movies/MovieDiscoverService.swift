//
//  MovieDiscoverService.swift
//  quemiras
//
//  Created by Agustina Markosich on 21/07/2020.
//  Copyright © 2020 Agustina. All rights reserved.
//

import UIKit
import AFNetworking

public protocol MovieDiscoverProtocol {
    func movieDiscoverSucceded(movies: MoviesArray)
    func movieDiscoverFailed(error: Error)
    
}

class MovieDiscoverService: NSObject {
    
    var delegate : MovieDiscoverProtocol?
    
    public func discoverMovies(userPreferences: UserMoviePreferences) {
        let manager = AFHTTPSessionManager(baseURL: URL(string: "https://api.themoviedb.org")!)
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        let selectedGenres = userPreferences.movieGenres.genres.filter { $0.isSelected == true }
        var params = [
            "language": "es",
            "include_adult":"false"
            ]
        
        if (MovieGenreAdapter.getMovieGenresParams(selectedGenres: selectedGenres).count > 0){
            params["with_genres"] = MovieGenreAdapter.getMovieGenresParams(selectedGenres: selectedGenres)
        }
        if (userPreferences.fromReleaseDate != nil) {
            params["primary_release_date.gte"] = userPreferences.fromReleaseDate
        }
        
        if (userPreferences.untilReleaseDate != nil){
            params["primary_release_date.lte"] = userPreferences.untilReleaseDate
        }
        
        params["sort_by"] = (userPreferences.mostPopular) ? "popularity.desc" : "popularity.asc"
        params["with_runtime.gte"] = userPreferences.runtime // + heuristic suma tiempo
        params["with_runtime.lte"] = userPreferences.runtime // + heuristic suma tiempo

        let headers = ["Authorization":apikey,
                       "Content-Type":"application/json;charset=utf-8"]
        
        manager.get("/3/discover/movie", parameters: params, headers: headers, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any) in
            print("success movies array")
            do {
                let dataJson = try JSONSerialization.data(withJSONObject: responseObject, options: JSONSerialization.WritingOptions.prettyPrinted)
                let moviesArray = try JSONDecoder().decode(MoviesArray.self, from: dataJson)
                print(moviesArray)
                
                //TODO: do heuristic
                    //to complete object with it Movie details
//                    self.getMovie(movie: movie)
                self.delegate?.movieDiscoverSucceded(movies: moviesArray)
//                }else{
                    //TODO: mostrar que no se encontro una peli
                    //self.delegate not founndddd
//                }
                
            } catch {
                print("Error decoding movie: " + error.localizedDescription)
                self.delegate?.movieDiscoverFailed(error: error)
            }
           
        }) { (task: URLSessionDataTask?, error: Error) in
            print("error" + error.localizedDescription)
            self.delegate?.movieDiscoverFailed(error: error)

        }
    }
    
    func getMovie(movie: Movie) {
        let manager = AFHTTPSessionManager(baseURL: URL(string: "https://api.themoviedb.org")!)
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        let params = [
            "language": "es",
            ]

        let headers = ["Authorization":apikey,
                       "Content-Type":"application/json;charset=utf-8"]
        
        manager.get("/3/movie/\(movie.id)", parameters: params, headers: headers, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any) in
            do {
                let dataJson = try JSONSerialization.data(withJSONObject: responseObject, options: JSONSerialization.WritingOptions.prettyPrinted)
                let movieDetails = try JSONDecoder().decode(MovieDetail.self, from: dataJson)
                var movieWithDetails: Movie = movie
                movieWithDetails.runtime = movieDetails.runtime
                movieWithDetails.genres = movieDetails.genres
                //TODO
//                self.delegate?.movieDiscoverSucceded(movie: movieWithDetails)
            }
            catch {
                print("Error decoding movie: " + error.localizedDescription)
                //TODO
//                self.delegate?.movieDiscoverFailed(error: error)
            }
           
        }) { (task: URLSessionDataTask?, error: Error) in
            print("error" + error.localizedDescription)
            //TODO
//            self.delegate?.movieDiscoverFailed(error: error)

        }
    }
}
