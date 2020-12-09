//
//  SortCollectionViewCell.swift
//  BucketPlace
//
//  Created by 김기현 on 2020/12/09.
//

import UIKit

class SortCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sortNameLabel: UILabel!
    @IBOutlet weak var closeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView.layer.cornerRadius = 18
    }

}
