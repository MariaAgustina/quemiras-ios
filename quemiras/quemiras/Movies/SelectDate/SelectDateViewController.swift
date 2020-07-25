//
//  SelectDateViewController.swift
//  quemiras
//
//  Created by Agustina Markosich on 24/07/2020.
//  Copyright © 2020 Agustina. All rights reserved.
//

import UIKit

public enum ReleaseDateType{
    case from
    case until
}

public protocol SelectDateDelegate {
    func datePicked(date: String,type: ReleaseDateType)
}


class SelectDateViewController: UIViewController {

    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleLabel: UILabel!
    var pickedDate : String?
    
    var releaseDateType : ReleaseDateType = .from
    var delegate : SelectDateDelegate?
    
    //TODO: validar que la fecha desde sea una fecha consistente con la fecha hasta y vicebersa (para mas adelante)
    override func viewDidLoad() {
        super.viewDidLoad()
        var dateString = ""
        switch releaseDateType {
            case .from:
                dateString = "desde:"
                break
            default:
                dateString = "hasta"
            }
        self.titleLabel.text = "Seleccionar fecha " + dateString
        setPickedDate(pickedDate: self.pickedDate)
    }
    
    func setPickedDate(pickedDate: String?){
        guard let userPreferenceDate = pickedDate else {
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.datePicker.date  = formatter.date(from:userPreferenceDate) ?? Date()
    }
    
    @IBAction func didPickDate(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.delegate?.datePicked(date: formatter.string(from: sender.date), type: releaseDateType)
    }
}
