//
//  ViewController.swift
//  Recipes
//
//  Created by Jeremy Conley on 9/28/16.
//  Copyright © 2016 JeremyConley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let url = "https://api.edamam.com/search?q=chicken&app_id=0a442613&app_key=9f9b54594dede3fa07416ca56f4925aa"
    var recipes = [Recipe]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getRecipe(url: url)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRecipe(url: String){
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        if let url = URL(string: url) {
            
            session.dataTask(with: url, completionHandler: {
                (data, response, error) in
                
                if error !=  nil {
                    print(error!)
                    return
                } else {
                    self.processData(data: data!)
                }
                
                
            }).resume()
            
        }
    }
    
    func processData(data: Data){
        print("processing")
        var json: NSDictionary!
        do {
            //Convert data to JSON
            json = try! JSONSerialization.jsonObject(with: data, options:.allowFragments) as! NSDictionary
            for recipe in json {
                if let hits = json["hits"] as? NSArray {
                    for hit in hits {
                        if let recipe = hit as? NSDictionary {
                            if let recipeDescrip = recipe["recipe"] as? NSDictionary {
                                let recipeTitle = recipeDescrip["label"] as? String
                                let recipeIngredients = recipeDescrip["ingredientLines"] as? NSArray
                                let recipeImgUrl = recipeDescrip["image"] as? String
                                
                                print(recipeTitle)
                                print(recipeIngredients)
                                print(recipeImgUrl)
                                
                                let recipe = Recipe(title: recipeTitle!, ingredients: recipeIngredients as! Array<String>, imageUrl: recipeImgUrl!)
                                recipes.append(recipe)
                            }
                        }
                    }
                }
            }
            for recipe in recipes {
                print(recipe.title)
            }
        }
    }
}



