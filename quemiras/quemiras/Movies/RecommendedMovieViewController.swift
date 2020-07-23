//
//  RecommendedMovieViewController.swift
//  quemiras
//
//  Created by Agustina Markosich on 21/07/2020.
//  Copyright © 2020 Agustina. All rights reserved.
//

import UIKit

class RecommendedMovieViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    public var movie : Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "¿Qué miras?"
        
        self.titleLabel.text = self.movie?.title ?? ""
        self.descriptionLabel.text = self.movie?.overview ?? ""
        getMovieImage()
        
    }
    
    func getMovieImage(){
        if let posterPath = movie?.poster_path{
            do {
               let url = URL(string: "https://image.tmdb.org/t/p/w500/" + posterPath)!
               let data = try Data(contentsOf : url)
               let image = UIImage(data : data )
               self.movieImageView.image = image
           }catch{
               print(error)
           }
        }
    }
    


}
