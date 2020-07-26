//
//  RecommendedMovieViewController.swift
//  quemiras
//
//  Created by Agustina Markosich on 21/07/2020.
//  Copyright © 2020 Agustina. All rights reserved.
//

import UIKit

protocol RecommendedMovieDelegate {
    func otherRecommendationsSelected(movie :Movie)
}

class RecommendedMovieViewController: LoadingViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    
    public var movie : Movie?
    public var delegate: RecommendedMovieDelegate?
    public var heuristic : Heuristic = Heuristic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "¿Qué miras?"
        updateViewWithMovie(movie: self.movie)

        
    }
    
    func updateViewWithMovie(movie: Movie?){
        if let movieToShow = movie {
            self.titleLabel.text = movieToShow.title
            self.descriptionLabel.text = self.movie?.overview ?? ""
            if let runtime = movieToShow.runtime{
                self.durationLabel.text = "Duración: " + "\(runtime)"
            }
            self.dateLabel.text = "Fecha estreno: " + (movieToShow.release_date)
            self.popularityLabel.text = "Popularidad: " +  String(describing: movieToShow.popularity)
            if let genres = movieToShow.genres{
                self.genresLabel.text = "Géneros: " + MovieGenreAdapter.getSelectedGenresTitle(selectedGenres: genres)
            }
            getMovieImage()
        }
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
    
    @IBAction func getAnotherRecommendationPressed(_ sender: UIButton) {
        guard let movie = self.movie else {
            return
        }
        
        heuristic.userMoviePreferences.seenMovies.append(movie.id)
        self.showActivityIndicator()
        heuristic.delegate = self
        heuristic.getMovieRecommendation()
    }
    
    @IBAction func seeMovieButtonPressed(_ sender: UIButton) {
        guard let movie = self.movie else {
            return
        }
        heuristic.userMoviePreferences.seenMovies.append(movie.id)
        navigationController?.popViewController(animated: true)
    }
    
}

extension RecommendedMovieViewController : HeuristicMovieDelegate{
    func heuristicMovieNotFound() {
        self.hideActivityIndicartor()
        let notFoundMovieViewController: NotFoundMovieViewController =
            NotFoundMovieViewController(nibName:"NotFoundMovieViewController",bundle: nil)
        self.navigationController?.pushViewController(notFoundMovieViewController, animated: true)

    }
    
    func heuristicMovieFound(movie : Movie){
        self.hideActivityIndicartor()
        
        self.movie = movie
        self.scrollView.setContentOffset(.zero, animated: true)
        updateViewWithMovie(movie: self.movie)
        

    }

}
