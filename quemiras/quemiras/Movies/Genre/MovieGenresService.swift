//
//  MovieGenresService.swift
//  quemiras
//
//  Created by Agustina Markosich on 22/07/2020.
//  Copyright © 2020 Agustina. All rights reserved.
//

import UIKit
import AFNetworking

public protocol MovieGenreProtocol {
    func movieGenreSucceded(genres: MovieGenres)
    func movieGenreFailed(error: Error)
    
}

class MovieGenresService: NSObject {
    var delegate : MovieGenreProtocol?
    
    public func getMovieGenres() {
        let manager = AFHTTPSessionManager(baseURL: URL(string: "https://api.themoviedb.org")!)
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        let params = [
            "language": "es",
            "include_adult":"false"
            ]
        
        let headers = ["Authorization":apikey,
                       "Content-Type":"application/json;charset=utf-8"
            ]
        
        manager.get("/3/genre/movie/list", parameters: params, headers: headers, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any) in
            print("success")
            do {
                let dataJson = try JSONSerialization.data(withJSONObject: responseObject, options: JSONSerialization.WritingOptions.prettyPrinted)
                let genres = try JSONDecoder().decode(MovieGenres.self, from: dataJson)
                self.delegate?.movieGenreSucceded(genres: genres)
            }
            catch {
                print("Error decoding movie: " + error.localizedDescription)
                self.delegate?.movieGenreFailed(error: error)
            }
           
        }) { (task: URLSessionDataTask?, error: Error) in
            print("error" + error.localizedDescription)
            self.delegate?.movieGenreFailed(error: error)

        }
    }
}
