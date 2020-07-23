//
//  Preferences.swift
//  quemiras
//
//  Created by Agustina Markosich on 22/07/2020.
//  Copyright © 2020 Agustina. All rights reserved.
//

import UIKit

public class ProfilePreference {
    
    var title : String?
    var preferenceType : PreferenceType
    
    init() {
        self.title = ""
        self.preferenceType = .selectGenre
    }
}
