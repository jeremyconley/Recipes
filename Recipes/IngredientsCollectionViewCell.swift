//
//  IngredientsCollectionViewCell.swift
//  Recipes
//
//  Created by Jeremy Conley on 2/4/17.
//  Copyright © 2017 JeremyConley. All rights reserved.
//

import UIKit

class IngredientsCollectionViewCell: UICollectionViewCell {
    let ingredientLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(ingredientLable)
        ingredientLable.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
