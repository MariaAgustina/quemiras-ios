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
    
    var preferenceToSelect : PreferenceToSelect = PreferenceToSelect()
    var heuristic : Heuristic = Heuristic()
    
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
        self.heuristic = Heuristic()
        self.heuristic.userMoviePreferences = UserMoviePreferences()

    }
    
    func setupProfilePreferenceTableView(){
        profilePreferencesTableView.register(UINib(nibName: "SelectPreferenceTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectPreferenceTableViewCell")
         profilePreferencesTableView.register(UINib(nibName: "DurationTableViewCell", bundle: nil), forCellReuseIdentifier: "DurationTableViewCell")
         profilePreferencesTableView.register(UINib(nibName: "PopularityTableViewCell", bundle: nil), forCellReuseIdentifier: "PopularityTableViewCell")
    }


    @IBAction func movieButtonPressed(_ sender: Any) {
        self.showActivityIndicator()
        heuristic.getMovieRecommendation()
        heuristic.delegate = self
        
    }
}


extension ProfileViewController : HeuristicMovieDelegate{
    func heuristicMovieFound(movie: Movie) {
        self.hideActivityIndicartor()
        let recommendedMovieViewController: RecommendedMovieViewController =
            RecommendedMovieViewController(nibName:"RecommendedMovieViewController",bundle: nil)
        
        recommendedMovieViewController.movie = movie
        recommendedMovieViewController.delegate = self
        recommendedMovieViewController.heuristic = self.heuristic
        self.navigationController?.pushViewController(recommendedMovieViewController, animated: true)
    }
    
    func heuristicMovieNotFound(){
        self.hideActivityIndicartor()
        let notFoundMovieViewController: NotFoundMovieViewController =
            NotFoundMovieViewController(nibName:"NotFoundMovieViewController",bundle: nil)
        self.navigationController?.pushViewController(notFoundMovieViewController, animated: true)

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
                selectGenreViewController.movieGenres = heuristic.userMoviePreferences.movieGenres
                selectGenreViewController.delegate = self
                self.navigationController?.pushViewController(selectGenreViewController, animated: true)
                break
            case .selectFromDate:
                let selectDateViewController: SelectDateViewController =
                    SelectDateViewController(nibName:"SelectDateViewController",bundle: nil)
                selectDateViewController.releaseDateType = .from
                selectDateViewController.pickedDate = heuristic.userMoviePreferences.fromReleaseDate
                selectDateViewController.delegate = self
                self.navigationController?.pushViewController(selectDateViewController, animated: true)
                break
            case .selectUntilDate:
                let selectDateViewController: SelectDateViewController =
                    SelectDateViewController(nibName:"SelectDateViewController",bundle: nil)
                selectDateViewController.releaseDateType = .until
                selectDateViewController.pickedDate = heuristic.userMoviePreferences.untilReleaseDate
                selectDateViewController.delegate = self
                self.navigationController?.pushViewController(selectDateViewController, animated: true)
                break
            case .selecDuration:
                break
            case .selectPopularity:
                break
        }

    }

}

extension ProfileViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.preferenceToSelect.preferences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let profilePreference : ProfilePreference = self.preferenceToSelect.preferences[indexPath.row]
        switch profilePreference.preferenceType {
            case .selectGenre:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPreferenceTableViewCell") as? SelectPreferenceTableViewCell {
                        let selectedGenres = heuristic.userMoviePreferences.movieGenres.genres.filter { $0.isSelected == true }
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
                    if let fromDate = heuristic.userMoviePreferences.fromReleaseDate {
                        cell.preferenceTitleLabel.text = "Fecha desde: " + fromDate
                    }else{
                        cell.preferenceTitleLabel.text = profilePreference.title
                    }
                    return cell
                }
                return UITableViewCell()
            case .selectUntilDate:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPreferenceTableViewCell") as? SelectPreferenceTableViewCell {
                   if let untilDate = heuristic.userMoviePreferences.untilReleaseDate {
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
                    cell.popularitySwitch.isOn = heuristic.userMoviePreferences.mostPopular
                    return cell
                }
                return UITableViewCell()
            case .selecDuration:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "DurationTableViewCell") as? DurationTableViewCell{
                    cell.durationTextField.text = heuristic.userMoviePreferences.runtime
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
        heuristic.userMoviePreferences.movieGenres = movieGenres
        self.profilePreferencesTableView.reloadData()

    }
}

extension ProfileViewController : SelectDateDelegate{
    func datePicked(date: String, type: ReleaseDateType) {
        switch type {
            case .from:
                heuristic.userMoviePreferences.fromReleaseDate = date
                break
            case .until:
                heuristic.userMoviePreferences.untilReleaseDate = date
                break
        }
        self.profilePreferencesTableView.reloadData()
    }
    
}
    
    
extension ProfileViewController: DurationSelectedDelegate{
    func durationSelected(duration: String){
        heuristic.userMoviePreferences.runtime = duration
    }
}

extension ProfileViewController: PoplarityDelegate {
    func popularitySelected(popularity: Bool){
        heuristic.userMoviePreferences.mostPopular = popularity
        self.profilePreferencesTableView.reloadData()
    }
    
}

extension ProfileViewController: RecommendedMovieDelegate {
    func otherRecommendationsSelected(movie: Movie) {
        heuristic.userMoviePreferences.seenMovies.append(movie.id)
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
