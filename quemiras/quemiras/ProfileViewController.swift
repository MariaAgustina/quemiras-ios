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
    @IBOutlet weak var profileTitle: UILabel!
    @IBOutlet weak var profilePreferencesTableView: UITableView!
    
    var userMoviePreferences : UserMoviePreferences = UserMoviePreferences()
    var preferenceToSelect : PreferenceToSelect = PreferenceToSelect()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "¿Qué miras?"
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""

        let loginButton = FBLoginButton()
        loginButtonContentView.addSubview(loginButton)
        loginButton.autoPinEdgesToSuperviewMargins()
        loginButton.delegate = self
        
        profilePreferencesTableView.register(UINib(nibName: "SelectPreferenceTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectPreferenceTableViewCell")
        
        self.profileTitle.text = "¡Bienvenido!"
        self.preferenceToSelect = PreferenceToSelect()
        
        //TODO: obtener estas preferencias desde backend
        self.userMoviePreferences = UserMoviePreferences()
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


extension ProfileViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.profilePreferencesTableView.deselectRow(at: indexPath, animated: true)
        let profilePreference : ProfilePreference = self.preferenceToSelect.preferences[indexPath.row]
        switch profilePreference.preferenceType {
        case .selectGenre:
            let selectGenreViewController: SelectGenreViewController =
                SelectGenreViewController(nibName:"SelectGenreViewController",bundle: nil)
            self.navigationController?.pushViewController(selectGenreViewController, animated: true)
        default:
            print("do nothing")
        }

    }

}

extension ProfileViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: de acuerdo a las opciones que le meta
        self.preferenceToSelect.preferences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let profilePreference : ProfilePreference = self.preferenceToSelect.preferences[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPreferenceTableViewCell") as? SelectPreferenceTableViewCell {
            cell.preferenceTitleLabel.text = profilePreference.title
            return cell
        }

        return UITableViewCell()
    }
    
    
}
