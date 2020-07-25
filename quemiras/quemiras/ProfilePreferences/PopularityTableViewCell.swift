//
//  PopularityTableViewCell.swift
//  quemiras
//
//  Created by Agustina Markosich on 25/07/2020.
//  Copyright © 2020 Agustina. All rights reserved.
//

import UIKit

protocol PoplarityDelegate {
    func popularitySelected(popularity: Bool)
}

class PopularityTableViewCell: UITableViewCell {

    @IBOutlet weak var popularitySwitch: UISwitch!
    var delegate : PoplarityDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func popularitySwitchTapped(_ sender: UISwitch) {
        self.delegate?.popularitySelected(popularity: sender.isOn)
    }
    
}
