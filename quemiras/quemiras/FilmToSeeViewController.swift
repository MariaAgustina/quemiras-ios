//
//  FilmToSeeViewController.swift
//  quemiras
//
//  Created by Agustina Markosich on 21/07/2020.
//  Copyright © 2020 Agustina. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var loginButtonContentView: UIView!
    var userMoviePreferences : UserMoviePreferences = UserMoviePreferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBLoginButton()
        loginButtonContentView.addSubview(loginButton)
        loginButton.autoPinEdgesToSuperviewMargins()
        loginButton.delegate = self
        
        //TODO: obtenerlos desde backend
        self.userMoviePreferences = UserMoviePreferences()
        getMovieGenres()
    }
    
    func getMovieGenres(){
        let movieGenresService : MovieGenresService = MovieGenresService()
        movieGenresService.delegate = self
        movieGenresService.getMovieGenres()
    }

    @IBAction func movieButtonPressed(_ sender: Any) {
        
        let service : MovieDiscoverService = MovieDiscoverService()
        service.delegate = self
        service.discoverMovies(userPreferences:self.userMoviePreferences)
        
    }
}

extension ProfileViewController : LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        //do nothing, only to logout
    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User logged out")
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController: LoginViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.pushViewController(loginViewController, animated: false)

    }
}

extension ProfileViewController : MovieDiscoverProtocol{
    func movieDiscoverSucceded(moviesArray: MoviesArray){
        let recommendedMovieViewController: RecommendedMovieViewController =
            RecommendedMovieViewController(nibName:"RecommendedMovieViewController",bundle: nil)
        recommendedMovieViewController.movie = moviesArray.results[6]
        self.navigationController?.pushViewController(recommendedMovieViewController, animated: true)
    }
    
    func movieDiscoverFailed(error: Error){
        //TODO
    }
}

extension ProfileViewController: MovieGenreProtocol{
    func movieGenreSucceded(genres: MovieGenres) {
        print("genresSucceded")
        //TODO: seleccionables desde el usuario (front end), por ahora hardcodedado
        self.userMoviePreferences.selectedGenres = [genres.genres[0],genres.genres[1]]
        
    }
    
    func movieGenreFailed(error: Error) {
        print("genresFailed")
    }
    
    
}
