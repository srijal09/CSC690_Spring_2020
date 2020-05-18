//
//  StudentTableViewCell.swift
//  StudentProfessorApp
//
//  Created by Mac-6 on 12/05/20.
//  Copyright © 2020 Mac-6. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {
    @IBOutlet var nameStud: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var statusImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
