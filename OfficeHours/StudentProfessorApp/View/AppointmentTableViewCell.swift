//
//  AppointmentTableViewCell.swift
//  StudentProfessorApp
//
//  Created by Mac-6 on 11/05/20.
//  Copyright © 2020 Mac-6. All rights reserved.
//

import UIKit

class AppointmentTableViewCell: UITableViewCell {

    @IBOutlet var statusImage: UIImageView!
    @IBOutlet var studName: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
