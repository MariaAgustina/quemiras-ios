//
//  SelectGenreViewController.swift
//  quemiras
//
//  Created by Agustina Markosich on 22/07/2020.
//  Copyright © 2020 Agustina. All rights reserved.
//

import UIKit

class SelectGenreViewController: LoadingViewController {

    @IBOutlet weak var genreTableView: UITableView!
    var movieGenres : MovieGenres? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genreTableView.register(UINib(nibName: "MovieGenreTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieGenreTableViewCell")
        getMovieGenres()

    }

    
    func getMovieGenres(){
        
        let movieGenresService : MovieGenresService = MovieGenresService()
        movieGenresService.delegate = self
        movieGenresService.getMovieGenres()
        self.showActivityIndicator()
    }
}


extension SelectGenreViewController: MovieGenreProtocol{
    func movieGenreSucceded(genres: MovieGenres) {
        self.hideActivityIndicartor()
        self.movieGenres = genres
        self.genreTableView.reloadData()
        print("genresSucceded")
        //TODO: seleccionables desde el usuario (front end), por ahora hardcodedado
//        self.userMoviePreferences.selectedGenres = [genres.genres[0],genres.genres[1]]
        
    }
    
    func movieGenreFailed(error: Error) {
        print("get genres failed " + error.localizedDescription)
        self.hideActivityIndicartor()
    }
}

extension SelectGenreViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if var movieGenre : MovieGenre = self.movieGenres?.genres[indexPath.row]{
            movieGenre.isSelected = !(movieGenre.isSelected ?? false)
        }
    }
}

extension SelectGenreViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.movieGenres?.genres.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let movieGenre : MovieGenre = self.movieGenres?.genres[indexPath.row], let cell = tableView.dequeueReusableCell(withIdentifier: "MovieGenreTableViewCell") as? MovieGenreTableViewCell {
            cell.genreTitle.text = movieGenre.name
            cell.isSelectedImageView.isHidden = !(movieGenre.isSelected ?? false)
            return cell
        }

        return UITableViewCell()
    }

}
