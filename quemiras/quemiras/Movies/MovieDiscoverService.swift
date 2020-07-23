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
    func movieDiscoverSucceded(moviesArray: MoviesArray)
    func movieDiscoverFailed(error: Error)
    
}

class MovieDiscoverService: NSObject {
    
    var delegate : MovieDiscoverProtocol?
    
    public func discoverMovies(userPreferences: UserMoviePreferences) {
        let manager = AFHTTPSessionManager(baseURL: URL(string: "https://api.themoviedb.org")!)
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        let selectedGenres = userPreferences.movieGenres.genres.filter { $0.isSelected == true }
        let params = [
            "language": "es",
            "include_adult":"false",
            "with_genres" : MovieGenreAdapter.getMovieGenresParams(selectedGenres: selectedGenres)
            ]
        
        let headers = ["Authorization":apikey,
                       "Content-Type":"application/json;charset=utf-8"]
        
        manager.get("/3/discover/movie", parameters: params, headers: headers, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any) in
            print("success movies array")
            do {
                let dataJson = try JSONSerialization.data(withJSONObject: responseObject, options: JSONSerialization.WritingOptions.prettyPrinted)
                let moviesArray = try JSONDecoder().decode(MoviesArray.self, from: dataJson)
                print(moviesArray)
                self.delegate?.movieDiscoverSucceded(moviesArray: moviesArray)
            }
            catch {
                print("Error decoding movie: " + error.localizedDescription)
                self.delegate?.movieDiscoverFailed(error: error)
            }
           
        }) { (task: URLSessionDataTask?, error: Error) in
            print("error" + error.localizedDescription)
            self.delegate?.movieDiscoverFailed(error: error)

        }
    }
}
