//
//  RecipeCollectionViewCell.swift
//  Recipes
//
//  Created by Jeremy Conley on 2/4/17.
//  Copyright © 2017 JeremyConley. All rights reserved.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
    
    let recipeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        //imageView.layer.cornerRadius = 5
        
        return imageView
    }()
    
    let recipeTitle: UILabel = {
        let label = UILabel()
        label.text = "Delicious Pasta For 2 Tonight"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(recipeImage)
        addSubview(recipeTitle)
        
        let imgFrameSize = frame.width - 40
        recipeImage.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: imgFrameSize, heightConstant: imgFrameSize)
        
        recipeTitle.anchor(recipeImage.bottomAnchor, left: self.recipeImage.leftAnchor, bottom: self.bottomAnchor, right: self.recipeImage.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
