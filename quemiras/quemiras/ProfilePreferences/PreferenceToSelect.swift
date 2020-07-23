//
//  PreferenceToSelect.swift
//  quemiras
//
//  Created by Agustina Markosich on 22/07/2020.
//  Copyright © 2020 Agustina. All rights reserved.
//

import UIKit

enum PreferenceType {
    case selectGenre
    case selectFromDate
    case selectUntilDate
}

class PreferenceToSelect {
    var preferences : Array<ProfilePreference> = []
    
    init(){
        self.preferences = []
        loadSelectGenrePreference()
    }
    
    func loadSelectGenrePreference(){
        
        let genrePreference = ProfilePreference()
        genrePreference.title = "Seleccionar género/s"
        genrePreference.preferenceType = .selectGenre
        
        self.preferences.append(genrePreference)
    }
}
