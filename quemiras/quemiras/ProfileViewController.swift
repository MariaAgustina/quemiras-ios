//
//  FilmToSeeViewController.swift
//  quemiras
//
//  Created by Agustina Markosich on 21/07/2020.
//  Copyright © 2020 Agustina. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ProfileViewController: LoadingViewController {

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
        
        self.profileTitle.text = "¡Bienvenido!"
        self.preferenceToSelect = PreferenceToSelect()
        setupProfilePreferenceTableView()
        
        //TODO: obtener estas preferencias desde backend
        self.userMoviePreferences = UserMoviePreferences()
    }
    
    func setupProfilePreferenceTableView(){
        profilePreferencesTableView.register(UINib(nibName: "SelectPreferenceTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectPreferenceTableViewCell")
         profilePreferencesTableView.register(UINib(nibName: "DurationTableViewCell", bundle: nil), forCellReuseIdentifier: "DurationTableViewCell")
         profilePreferencesTableView.register(UINib(nibName: "PopularityTableViewCell", bundle: nil), forCellReuseIdentifier: "PopularityTableViewCell")
    }


    @IBAction func movieButtonPressed(_ sender: Any) {
        self.showActivityIndicator()
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
        self.hideActivityIndicartor()
        let recommendedMovieViewController: RecommendedMovieViewController =
            RecommendedMovieViewController(nibName:"RecommendedMovieViewController",bundle: nil)
        
        if(moviesArray.results.count > 0){
            //TODO: heuristica
            recommendedMovieViewController.movie = moviesArray.results[0]
            self.navigationController?.pushViewController(recommendedMovieViewController, animated: true)
        }else{
            //TODO: mostrar que no hay pelis
            print("No hay pelis")
        }
    }
    
    func movieDiscoverFailed(error: Error){
        self.hideActivityIndicartor()
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
                selectGenreViewController.movieGenres = self.userMoviePreferences.movieGenres
                selectGenreViewController.delegate = self
                self.navigationController?.pushViewController(selectGenreViewController, animated: true)
                break
            case .selectFromDate:
                let selectDateViewController: SelectDateViewController =
                    SelectDateViewController(nibName:"SelectDateViewController",bundle: nil)
                selectDateViewController.releaseDateType = .from
                selectDateViewController.pickedDate = userMoviePreferences.fromReleaseDate
                selectDateViewController.delegate = self
                self.navigationController?.pushViewController(selectDateViewController, animated: true)
                break
            case .selectUntilDate:
                let selectDateViewController: SelectDateViewController =
                    SelectDateViewController(nibName:"SelectDateViewController",bundle: nil)
                selectDateViewController.releaseDateType = .until
                selectDateViewController.pickedDate = userMoviePreferences.untilReleaseDate
                selectDateViewController.delegate = self
                self.navigationController?.pushViewController(selectDateViewController, animated: true)
                break
            case .selecDuration:
                //TODO
                break
            case .selectPopularity:
                //TODO
                break
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
        switch profilePreference.preferenceType {
            case .selectGenre:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPreferenceTableViewCell") as? SelectPreferenceTableViewCell {
                        let selectedGenres = userMoviePreferences.movieGenres.genres.filter { $0.isSelected == true }
                        if selectedGenres.count > 0 {
                            cell.preferenceTitleLabel.text = "Géneros seleccionados: " + MovieGenreAdapter.getSelectedGenresTitle(selectedGenres: selectedGenres)
                        }else{
                            cell.preferenceTitleLabel.text = profilePreference.title
                        }
                        return cell
                    }
                return UITableViewCell()
            case .selectFromDate:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPreferenceTableViewCell") as? SelectPreferenceTableViewCell {
                    if let fromDate = self.userMoviePreferences.fromReleaseDate {
                        cell.preferenceTitleLabel.text = "Fecha desde: " + fromDate
                    }else{
                        cell.preferenceTitleLabel.text = profilePreference.title
                    }
                    return cell
                }
                return UITableViewCell()
            case .selectUntilDate:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPreferenceTableViewCell") as? SelectPreferenceTableViewCell {
                   if let untilDate = self.userMoviePreferences.untilReleaseDate {
                       cell.preferenceTitleLabel.text = "Fecha hasta: " + untilDate
                   }else{
                       cell.preferenceTitleLabel.text = profilePreference.title
                   }
                   return cell
               }
               return UITableViewCell()
            case .selectPopularity:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "PopularityTableViewCell") as? PopularityTableViewCell {
                    cell.delegate = self
                    cell.popularitySwitch.isOn = self.userMoviePreferences.mostPopular
                    return cell
                }
                return UITableViewCell()
            case .selecDuration:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "DurationTableViewCell") as? DurationTableViewCell{
                    cell.durationTextField.text = self.userMoviePreferences.runtime
                    cell.delegate = self
                    return cell
                }
                return UITableViewCell()
            }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension ProfileViewController : SelectGenreProtocol{
    func movieGenresDidChange(movieGenres: MovieGenres) {
        self.userMoviePreferences.movieGenres = movieGenres
        self.profilePreferencesTableView.reloadData()

    }
}

extension ProfileViewController : SelectDateDelegate{
    func datePicked(date: String, type: ReleaseDateType) {
        switch type {
            case .from:
                self.userMoviePreferences.fromReleaseDate = date
                break
            case .until:
                self.userMoviePreferences.untilReleaseDate = date
                break
        }
        self.profilePreferencesTableView.reloadData()
    }
    
}
    
    
extension ProfileViewController : DurationSelectedDelegate{
    func durationSelected(duration: String){
        self.userMoviePreferences.runtime = duration
    }
}

extension ProfileViewController :PoplarityDelegate {
    func popularitySelected(popularity: Bool){
        self.userMoviePreferences.mostPopular = popularity
        self.profilePreferencesTableView.reloadData()
    }
    
}
