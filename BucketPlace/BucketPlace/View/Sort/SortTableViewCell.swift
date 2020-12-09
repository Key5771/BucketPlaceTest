//
//  SortTableViewCell.swift
//  BucketPlace
//
//  Created by 김기현 on 2020/12/08.
//

import UIKit

class SortTableViewCell: UITableViewCell {
    @IBOutlet weak var sortLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            sortLabel.textColor = UIColor(red: 53 / 255, green: 197 / 255, blue: 240 / 255, alpha: 1)
        }
    }
    
}
