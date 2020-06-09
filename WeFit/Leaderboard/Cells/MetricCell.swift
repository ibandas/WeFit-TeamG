//
//  MetricCell.swift
//  WeFit
//
//  Created by Irinel Bandas on 6/9/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import UIKit

class MetricCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTitle(title: String) {
        self.title.text = title
    }

}
