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
    case selecDuration
    case selectPopularity
}

class PreferenceToSelect {
    var preferences : Array<ProfilePreference> = []
    
    init(){
        self.preferences = []
        loadSelectGenrePreference()
        loadDateFromPrefrence()
        loadDateUntilPrefrence()
        loadDurationPreference()
        loadPopularityPrefenrence()
    }
    
    func loadSelectGenrePreference(){
        
        let preference = ProfilePreference()
        preference.title = "Seleccionar género/s"
        preference.preferenceType = .selectGenre
        
        self.preferences.append(preference)
    }
    
    func loadDateFromPrefrence(){
        let preference = ProfilePreference()
        preference.title = "Seleccionar fecha desde"
        preference.preferenceType = .selectFromDate
        self.preferences.append(preference)

    }
    
    func loadDateUntilPrefrence(){
        let preference = ProfilePreference()
        preference.title = "Seleccionar fecha hasta"
        preference.preferenceType = .selectUntilDate
        self.preferences.append(preference)

    }

    func loadDurationPreference(){
        let preference = DurationProfilePreference()
        preference.title = "Duración: "
        preference.preferenceType = .selecDuration
        preference.selectedDuration = "90"
        self.preferences.append(preference)
    }
    
    func loadPopularityPrefenrence(){
        let preference = PopularityProfilePreference()
        preference.title = "Más populares"
        preference.preferenceType = .selectPopularity
        preference.isSelected = true
        self.preferences.append(preference)
    }
    

    
}
