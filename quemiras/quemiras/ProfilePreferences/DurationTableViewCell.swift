//
//  DurationTableViewCell.swift
//  quemiras
//
//  Created by Agustina Markosich on 25/07/2020.
//  Copyright © 2020 Agustina. All rights reserved.
//

import UIKit

protocol DurationSelectedDelegate {
    func durationSelected(duration: String)
}

class DurationTableViewCell: UITableViewCell {

    @IBOutlet weak var durationTextField: UITextField!
    var delegate : DurationSelectedDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func durationChanged(_ sender: Any) {
           self.delegate?.durationSelected(duration: self.durationTextField.text ?? "")
    }
    
}
