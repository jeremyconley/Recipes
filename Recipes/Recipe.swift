//
//  Recipe.swift
//  Recipes
//
//  Created by Jeremy Conley on 2/4/17.
//  Copyright © 2017 JeremyConley. All rights reserved.
//

import Foundation

struct Recipe {
    let title: String
    let ingredients: Array<String>
    let imageUrl: String
    
    func toAnyObject() -> Any {
        return [
            "title": title,
            "ingredients": ingredients,
            "imageUrl": imageUrl
        ]
    }
}
