//
//  PhotoCell.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 30.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet var photo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = UIImage(named: "placeholder-user.png")
        photo.image = image
    }
    
    override func prepareForReuse() {
        let image = UIImage(named: "placeholder-user.png")
        photo.image = image
    }
    
    func configureCell(image: UIImage?) {
        photo.image = image
    }
    
}
