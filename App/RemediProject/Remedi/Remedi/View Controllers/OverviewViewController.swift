//
//  OverviewViewController.swift
//  Remedi
//
//  Created by Ngan Nguyen on 2019-11-25.
//  Copyright © 2019 Krystal Nguyen. All rights reserved.
//

import UIKit

class OverviewViewController: UICollectionViewController {
    // overview page controller array
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.nextView(viewController: "PiePageView"),
                self.nextView(viewController: "BarPageView")]
    }()
    
    // page control, which allows page dots
    var pageControl = UIPageControl()
    
    // default page control functions  start ---->
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // if user is on first page and swipes left
        guard previousIndex >= 0 else {
            return orderedViewControllers.last // loops back
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // if user is on last page and swipes right
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    // default page control functions  end ---->
    
    
    // loads view controller based off storyboardid
    func nextView(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.dataSource = self
//        self.navigationController?.navigationBar.prefersLargeTitles = false
//        // sets up the first view that will show up on our page control
//        if let firstViewController = orderedViewControllers.first {
//            setViewControllers([firstViewController],direction: .forward, animated: true, completion: nil)
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
