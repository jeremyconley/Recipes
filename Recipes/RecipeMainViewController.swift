//
//  RecipeMainViewController.swift
//  Recipes
//
//  Created by Jeremy Conley on 2/4/17.
//  Copyright © 2017 JeremyConley. All rights reserved.
//

import UIKit

class RecipeMainViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UITextFieldDelegate {
    
    var collectionView: UICollectionView?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var alert: UIAlertController?
    
    
    let url = "https://api.edamam.com/search?q=chicken&app_id=0a442613&app_key=9f9b54594dede3fa07416ca56f4925aa&from=0&to=30"
    
    var recipes = [Recipe]()
    
    var selectedRecipe: Recipe?
    
    //Activity Indicator
    var activityIndicator = UIActivityIndicatorView()
    var container = UIView()
    
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationItem.title = "Reci-p's"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleContainer = UIView()
        titleContainer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: 50)
        titleContainer.center.x = view.center.x
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: 50))
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "amarillo", size: 16)
        titleLabel.textColor = .white
        titleLabel.text = "Reci-p's"
        titleContainer.addSubview(titleLabel)
        
        self.navigationItem.titleView = titleContainer
        
        
        //Setup Activity Indicator
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.rightBarButtonItem = barButton
        
        

        
        let layout = UICollectionViewFlowLayout()
        //layout.minimumLineSpacing = 0
        //layout.minimumInteritemSpacing = 1
        let widthSize = self.view.frame.width / 2 - 2
        layout.itemSize = CGSize(width: widthSize, height: widthSize + 30)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView?.backgroundColor = .white
        collectionView?.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: "recipeCollectionCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        searchBar.delegate = self
        searchBar.placeholder = "Chicken"
        
        //Load Recipes
        getRecipe(url: url, searchedItem: "chicken")
        
        setupViews()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
    
    func setupViews(){
        let height = self.navigationController?.navigationBar.frame.height
        
        
        searchBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: height!)
        searchBar.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        searchBar.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        
        
        view.addSubview(collectionView!)
        //For initial animation
        collectionView?.alpha = 0
        collectionView?.anchor(searchBar.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        
    }
    
    //Alert Functions
    func noResultsAlert(searchedItem: String){
        alert = UIAlertController(title: "No Results", message: "No recipes for \(searchedItem)", preferredStyle: UIAlertControllerStyle.alert)
        alert?.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert!, animated: true, completion: nil)
    }
    
    func handleSelectedRecipe(recipe: Recipe){
        selectedRecipe = recipe
        self.performSegue(withIdentifier: "toRecipeDetail", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCollectionCell", for: indexPath) as! RecipeCollectionViewCell
        cell.backgroundColor = .white
        cell.layer.masksToBounds = false
        cell.layer.cornerRadius = 5
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        //Setup recipe data
        let recipe = recipes[indexPath.row]
        cell.recipeTitle.text = recipe.title
        cell.recipeImage.loadImgUsingCacheWithUrlString(urlString: recipe.imageUrl, type:"")
        
        
        
        return cell
    }
    
    func collectionViewReloadDataWithAnimation(){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            self.collectionView?.alpha = 0
            }, completion: { (completedAnimation) in
                //Reload data once table view is hidden
                self.collectionView?.reloadData()
                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
                    self.collectionView?.alpha = 1
                    }, completion: { (completedAnimation) in
                        self.activityIndicator.stopAnimating()
                })
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handleSelectedRecipe(recipe: recipes[indexPath.row])
    }
    
    func getRecipe(url: String, searchedItem: String){
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        activityIndicator.startAnimating()
        
        if let url = URL(string: url) {
            session.dataTask(with: url, completionHandler: {
                (data, response, error) in
                
                if error !=  nil {
                    print(error!)
                    self.noResultsAlert(searchedItem: searchedItem)
                    self.activityIndicator.stopAnimating()
                    return
                } else {
                    self.processData(data: data!, searchedItem: searchedItem)
                    
                }
            }).resume()
        } else {
            self.noResultsAlert(searchedItem: searchedItem)
            self.activityIndicator.stopAnimating()
        }
    }
    
    func processData(data: Data, searchedItem: String){
        print("processing")
        var json: NSDictionary!
        do {
            //Convert data to JSON
            recipes.removeAll()
            json = try! JSONSerialization.jsonObject(with: data, options:.allowFragments) as! NSDictionary
            for recipe in json {
                if let hits = json["hits"] as? NSArray {
                    for hit in hits {
                        if let recipe = hit as? NSDictionary {
                            if let recipeDescrip = recipe["recipe"] as? NSDictionary {
                                var itemIsInArray = false
                                
                                let recipeTitle = recipeDescrip["label"] as? String
                                let recipeIngredients = recipeDescrip["ingredientLines"] as? NSArray
                                let recipeImgUrl = recipeDescrip["image"] as? String
                                
                                print(recipeTitle)
                                print(recipeIngredients)
                                print(recipeImgUrl)
                                
                                for recipe in recipes {
                                    if recipe.title == recipeTitle {
                                        itemIsInArray = true
                                    }
                                }
                                
                                if itemIsInArray == false {
                                    let recipe = Recipe(title: recipeTitle!, ingredients: recipeIngredients as! Array<String>, imageUrl: recipeImgUrl!)
                                    recipes.append(recipe)
                                }
                            }
                        }
                    }
                }
            }
            //Refresh Cells
            DispatchQueue.main.async {
                self.collectionView?.setContentOffset(CGPoint.zero, animated: true)
                self.collectionViewReloadDataWithAnimation()
                if self.recipes.count <= 0 {
                    self.noResultsAlert(searchedItem: searchedItem)
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        print(searchBar.text)
        let searchText = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print(searchText)
        getRecipe(url: "https://api.edamam.com/search?q=\(searchText!)&app_id=0a442613&app_key=9f9b54594dede3fa07416ca56f4925aa&from=0&to=30", searchedItem: searchBar.text!)
    }
    
  
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthSize = self.view.frame.width / 2 - 2
        var size = CGSize(width: widthSize, height: widthSize)
        let num = indexPath.row
        if num % 2 == 0 {
            size = CGSize(width: widthSize, height: widthSize + 20)
        }
        return size
    }
    */
 
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toRecipeDetail"{
            let destinationController = segue.destination as! RecipeDetailViewController
            destinationController.recipe = selectedRecipe
        }
    }
 

}

