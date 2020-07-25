//
//  SelectGenreViewController.swift
//  quemiras
//
//  Created by Agustina Markosich on 22/07/2020.
//  Copyright © 2020 Agustina. All rights reserved.
//

import UIKit

public protocol SelectGenreProtocol {
    func movieGenresDidChange(movieGenres: MovieGenres)
}

class SelectGenreViewController: LoadingViewController {

    @IBOutlet weak var genreTableView: UITableView!
    
    var movieGenres : MovieGenres = MovieGenres(genres: [])
    var delegate : SelectGenreProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genreTableView.register(UINib(nibName: "MovieGenreTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieGenreTableViewCell")
        getMovieGenresIfNeeded()

    }

    
    func getMovieGenresIfNeeded(){
        if movieGenres.genres.count == 0{
            let movieGenresService : MovieGenresService = MovieGenresService()
            movieGenresService.delegate = self
            movieGenresService.getMovieGenres()
            self.showActivityIndicator()
        }
    }
}


extension SelectGenreViewController: MovieGenreProtocol{
    func movieGenreSucceded(genres: MovieGenres) {
        self.hideActivityIndicartor()
        self.movieGenres = genres
        self.genreTableView.reloadData()
        
    }
    
    func movieGenreFailed(error: Error) {
        print("get genres failed " + error.localizedDescription)
        self.hideActivityIndicartor()
    }
}

extension SelectGenreViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var movieGenre : MovieGenre = self.movieGenres.genres[indexPath.row]
        let movieGenreIsSelectedValue = movieGenre.isSelected ?? false
        movieGenre.isSelected = !(movieGenreIsSelectedValue)
        self.movieGenres.genres[indexPath.row] = movieGenre
        
        self.delegate?.movieGenresDidChange(movieGenres: self.movieGenres)
        self.genreTableView.reloadData()
    }
}

extension SelectGenreViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.movieGenres.genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movieGenre : MovieGenre = self.movieGenres.genres[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieGenreTableViewCell") as? MovieGenreTableViewCell {
            cell.genreTitle.text = movieGenre.name
            let movieGenreIsSelectedValue = movieGenre.isSelected ?? false
            cell.isSelectedImageView.isHidden = !(movieGenreIsSelectedValue)
            return cell
        }

        return UITableViewCell()
    }

}
