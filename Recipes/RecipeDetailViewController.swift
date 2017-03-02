//
//  RecipeDetailViewController.swift
//  Recipes
//
//  Created by Jeremy Conley on 2/4/17.
//  Copyright © 2017 JeremyConley. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var recipe: Recipe?
    var ingredients = Array<String>()
    
    var ingredientCollectionView: UICollectionView?
    
    let recipeImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let recipeTitle: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    let ingredientsHeader: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .red
        label.text = "Ingredients:"
        return label
    }()
    
    var ingredientLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()

    //Setup nav image
    let spoonImgView = UIImageView(image: #imageLiteral(resourceName: "spoon"))
    let knifeImgView = UIImageView(image: #imageLiteral(resourceName: "knife"))
    let forkImgView = UIImageView(image: #imageLiteral(resourceName: "fork"))
    var containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.title = "Recipe"
        self.navigationController!.navigationBar.topItem!.title = ""
        
        //Setup nav image
        let containerWidth = self.view.frame.width / 2
        
        containerView.frame = CGRect(x: 0, y: 0, width: containerWidth, height: 50)
        containerView.center.x = view.center.x
        
        
        let centerPosition = (containerWidth / 2) - (45 / 2)

        
        knifeImgView.frame = CGRect(x: centerPosition, y: 0, width: 45, height: 45)
        //Set to the right initially
        spoonImgView.frame = CGRect(x: centerPosition + self.view.frame.width, y: 0, width: 45, height: 45)
        //Set to the left initially
        forkImgView.frame = CGRect(x: centerPosition - self.view.frame.width, y: 0, width: 45, height: 45)
        
        spoonImgView.contentMode = .scaleAspectFit
        knifeImgView.contentMode = .scaleAspectFit
        forkImgView.contentMode = .scaleAspectFit
        
        containerView.addSubview(spoonImgView)
        containerView.addSubview(knifeImgView)
        containerView.addSubview(forkImgView)
        
        self.navigationItem.titleView = containerView
        
        //NavAnimation
        let spoonMoveAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        spoonMoveAnimation.duration = 0.5
        spoonMoveAnimation.fromValue = 0
        spoonMoveAnimation.toValue = -(self.view.frame.width + 6)
        
        let spoonRotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        spoonRotationAnimation.fromValue = 0 * CGFloat(M_PI/180)
        spoonRotationAnimation.toValue = -45 * CGFloat(M_PI/180)
        spoonRotationAnimation.duration = 0.5
        
        let spoonAnimation = CAAnimationGroup()
        spoonAnimation.animations = [spoonMoveAnimation, spoonRotationAnimation]
        spoonAnimation.isRemovedOnCompletion = false
        spoonAnimation.duration = 0.5
        spoonAnimation.fillMode = kCAFillModeForwards
        
        spoonImgView.layer.add(spoonAnimation, forKey: "rotateAndMove")
        
        let forkMoveAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        forkMoveAnimation.duration = 0.5
        forkMoveAnimation.fromValue = 0
        forkMoveAnimation.toValue = (self.view.frame.width + 4)
        
        let forkRotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        forkRotationAnimation.fromValue = 0 * CGFloat(M_PI/180)
        forkRotationAnimation.toValue = 45 * CGFloat(M_PI/180)
        forkRotationAnimation.duration = 0.5
        
        let forkAnimation = CAAnimationGroup()
        forkAnimation.animations = [forkMoveAnimation, forkRotationAnimation]
        forkAnimation.isRemovedOnCompletion = false
        forkAnimation.duration = 0.5
        forkAnimation.fillMode = kCAFillModeForwards
        
        forkImgView.layer.add(forkAnimation, forKey: "rotateAndMove")
        
        
        
        let layout = UICollectionViewFlowLayout()
        
        ingredientCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        ingredientCollectionView?.backgroundColor = .white
        ingredientCollectionView?.register(IngredientsCollectionViewCell.self, forCellWithReuseIdentifier: "ingredientCollectionCell")
        ingredientCollectionView?.delegate = self
        ingredientCollectionView?.dataSource = self
        
        if let currentRecipe = recipe {
            setupViews()
            ingredients = currentRecipe.ingredients
            ingredientCollectionView?.reloadData()
        }
        
        

        // Do any additional setup after loading the view.
    }
    
    func setupViews(){
        
        //Title and Image Views
        self.view.addSubview(recipeImage)
        self.view.addSubview(recipeTitle)
        self.view.addSubview(ingredientsHeader)
        self.view.addSubview(ingredientCollectionView!)
        
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        
        recipeTitle.text = recipe?.title
        recipeImage.loadImgUsingCacheWithUrlString(urlString: (recipe?.imageUrl)!, type: "")
        
        
        
        recipeImage.clipsToBounds = false
        recipeImage.layer.shadowColor = UIColor.black.cgColor
        recipeImage.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        recipeImage.layer.shadowRadius = 3.0
        recipeImage.layer.shadowOpacity = 1.0
        
    
        recipeImage.anchor(self.view.topAnchor, left: nil, bottom: nil, right: self.view.rightAnchor, topConstant: navBarHeight! * 2, leftConstant: 10, bottomConstant: 0, rightConstant: 20, widthConstant: self.view.frame.width / 2, heightConstant: self.view.frame.width / 2)
        
        if UIScreen.main.bounds.width >= 375 {
            //iPhone 6 and up
            recipeTitle.font = UIFont.boldSystemFont(ofSize: 20)
        } else {
            recipeTitle.font = UIFont.boldSystemFont(ofSize: 19)
        }
        
        if (recipeTitle.text?.characters.count)! >= 30 {
            recipeTitle.anchor(nil, left: self.view.leftAnchor, bottom: recipeImage.bottomAnchor, right: recipeImage.leftAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        } else {
            recipeTitle.anchor(recipeImage.topAnchor, left: self.view.leftAnchor, bottom: nil, right: recipeImage.leftAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        }
        
        
        //Seperator View
        let seperatorView = UIView()
        seperatorView.backgroundColor = .gray
        self.view.addSubview(seperatorView)
        
        seperatorView.anchor(recipeImage.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: self.view.frame.width, heightConstant: 1)
        
        //Ingredient Views
        ingredientsHeader.anchor(seperatorView.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 10, leftConstant: 15, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 0)
        
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.red.cgColor]
        gradientLayer.frame = ingredientsHeader.bounds
        gradientLayer.locations = [0.7, 1.2]
        ingredientsHeader.layer.addSublayer(gradientLayer)
    
        
        ingredientCollectionView?.anchor(ingredientsHeader.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        
        /*
        var previousLabel: UILabel?
        for ingredient in ingredients! {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.numberOfLines = 0
            label.text = "- \(ingredient)"
            scrollView.addSubview(label)
            if let prevLabel = previousLabel {
                label.anchor(prevLabel.bottomAnchor, left: prevLabel.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 0)
                previousLabel = label
            } else {
                label.anchor(scrollView.topAnchor, left: ingredientsHeader.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 0)
                previousLabel = label
            }
        }
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ingredientCollectionCell", for: indexPath) as! IngredientsCollectionViewCell
        cell.backgroundColor = .white
        cell.layer.masksToBounds = false
        cell.layer.cornerRadius = 2
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        cell.ingredientLable.text = ingredients[indexPath.row]
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //Get estimation of cell height based on user.bioText
        let ingredient = ingredients[indexPath.row]
        let approximateWidth = view.frame.width - 12 - 50 - 12 - 2
        let size = CGSize(width: approximateWidth, height: 1000)
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 15)]
        let estimatedFrame = NSString(string: ingredient).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        let height = CGFloat(estimatedFrame.height + 30)
        
        
        return (CGSize(width: collectionView.frame.width - 30, height: height))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
