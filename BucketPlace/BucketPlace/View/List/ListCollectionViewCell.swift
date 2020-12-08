//
//  ListCollectionViewCell.swift
//  BucketPlace
//
//  Created by 김기현 on 2020/12/06.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        descriptionLabel.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.left
        layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return layoutAttributes
    }
}
