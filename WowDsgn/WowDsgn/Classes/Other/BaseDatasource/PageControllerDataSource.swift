//
//  PageControllerDataSource.swift
//  Wow
//
//  Created by 小黑 on 16/4/7.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation

/*
enum SNVError: ErrorType {
    case ControllerNotFound(description:String)
}

@ob class PageControllerDataSource:NSObject{
    
    private var viewIdsToViewControllers:[String:UIViewController] = [String:UIViewController]()
    private var viewControllerIdentifiers : [String] = []
    private var storyBoard : UIStoryboard!
    var controllers:[UIViewController] = []

    init(pageController:UIPageViewController,viewControllersIds:[String],storyboardName:String){
        assert(viewControllersIds.count > 0)
        super.init()
        self.viewControllerIdentifiers +=  viewControllersIds
        self.storyBoard = UIStoryboard(name:storyboardName, bundle:NSBundle.mainBundle())
        pageController.dataSource = self
        for (index,identifier) in self.viewControllerIdentifiers.enumerate() {
            self.viewIdsToViewControllers["\(index)"] = self.storyBoard.instantiateViewControllerWithIdentifier(identifier)
            controllers.append(self.viewIdsToViewControllers["\(index)"]!)
        }
        pageController.setViewControllers([controllers[0]], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }
    
}

extension PageControllerDataSource:UIPageViewControllerDataSource{
    @objc func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vcIndex = controllers.indexOf(viewController)
        if vcIndex >= controllers.count - 1{
            return nil
        }else{
            return controllers[vcIndex! + 1]
        }

//        do {
//            let index = try self.indexOfController(viewController)
//            if (index >= self.viewControllerIdentifiers.count - 1){
//                return nil
//            }
//            let identifier = self.viewControllerIdentifiers[index + 1]
//            return self.viewIdsToViewControllers[identifier]
//        } catch SNVError.ControllerNotFound(let description){
//            print("error\(description)")
//            return nil
//        }
//        catch {
//            return nil
//        }
    }
    
    @objc func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vcIndex = controllers.indexOf(viewController)
        if vcIndex <= 0{
            return nil
        }else{
            return controllers[vcIndex! - 1]
        }

//        do {
//            let index = try self.indexOfController(viewController)
//            if (index == 0){
//                return nil
//            }
//            let identifier = self.viewControllerIdentifiers[index - 1]
//            return self.viewIdsToViewControllers[identifier]
//        } catch SNVError.ControllerNotFound(let description){
//            print("error\(description)")
//            return nil
//        }
//        catch {
//            return nil
//        }
    }
    
    
    private func indexOfController(controller:UIViewController)throws->Int  {
        for storyboardID in self.viewControllerIdentifiers {
            if self.viewIdsToViewControllers[storyboardID] == controller {
                return self.viewControllerIdentifiers.indexOf(storyboardID)!
            }
        }
        throw SNVError.ControllerNotFound(description: "Not found controller:\(controller) in collection:\(self.viewIdsToViewControllers)")
    }
}
 */