//
//  TabBarController.swift
//  flick
//
//  Created by ruiyang_wu on 8/4/16.
//  Copyright © 2016 ruiyang_wu. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        print("Selected item")
        //let tabBarController = TabBarController()
        //tabBarController.viewControllers = [nowPlayingNavigationController, topRatedNavigationController]
        for controller in self.viewControllers! {
            let navController = controller as! UINavigationController
            let viewController = navController.topViewController as! ActiveMoviesController
            
            if viewController.modeControl != nil {
                viewController.modeControl.selectedSegmentIndex = ActiveMoviesController.modeSelection
                viewController.modeChanged(viewController)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
