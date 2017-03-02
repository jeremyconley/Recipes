//
//  LaunchAnimationViewController.swift
//  Recipes
//
//  Created by Jeremy Conley on 2/17/17.
//  Copyright © 2017 JeremyConley. All rights reserved.
//

import UIKit

class LaunchAnimationViewController: UIViewController {
    
    let knifeImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = #imageLiteral(resourceName: "knife")
        return imgView
    }()
    let forkImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = #imageLiteral(resourceName: "fork")
        return imgView
    }()
    let spoonImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = #imageLiteral(resourceName: "spoon")
        return imgView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        view.addSubview(knifeImgView)
        view.addSubview(forkImgView)
        view.addSubview(spoonImgView)
        
        knifeImgView.frame.size = CGSize(width: 100, height: 152)
        forkImgView.frame.size = CGSize(width: 100, height: 152)
        spoonImgView.frame.size = CGSize(width: 100, height: 152)
        
        //Initial Image Positions
        knifeImgView.frame = CGRect(x: 0, y: self.view.center.y - (knifeImgView.frame.size.height / 2), width: knifeImgView.frame.size.width, height: knifeImgView.frame.size.height)
        knifeImgView.center.x = self.view.center.x + 10
        
        spoonImgView.frame = CGRect(x: self.view.frame.maxX, y: self.view.center.y - (spoonImgView.frame.size.height / 2), width: spoonImgView.frame.size.width, height: spoonImgView.frame.size.height)
        forkImgView.frame = CGRect(x: -forkImgView.frame.size.width, y: self.view.center.y - (forkImgView.frame.size.height / 2), width: forkImgView.frame.size.width, height: forkImgView.frame.size.height)
        
        let spoonMoveAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        spoonMoveAnimation.duration = 0.5
        spoonMoveAnimation.fromValue = 0
        spoonMoveAnimation.toValue = -(self.view.center.x + 70)
        
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
        forkMoveAnimation.toValue = (self.view.center.x + 80)
        
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
        
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (timer) in
                self.addArch()
            }
        } else {
            // Fallback on earlier versions
            
            self.segueToNavController()
        }
 
        
    
    }
    
    func addArch(){
        let archLayer = ArcLayer()
        archLayer.frame = CGRect(x: 0, y: 0, width: archLayer.frame.width, height: archLayer.frame.height)
        self.view.layer.addSublayer(archLayer)
        archLayer.animate()
        
       
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
                self.segueToNavController()
            }
        } else {
            // Fallback on earlier versions
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func segueToNavController(){
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "launchComplete", sender: self)
        }
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
