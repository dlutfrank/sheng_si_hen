//
//  ChangduanTableViewCell.swift
//  T1
//
//  Created by gong on 21/03/2017.
//  Copyright © 2017 Ramunas Jurgilas. All rights reserved.
//

import UIKit

class ChangduanTableViewCell: UITableViewCell {

    @IBOutlet weak var changduanNameLabel: UILabel!
    @IBOutlet weak var downloadBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
