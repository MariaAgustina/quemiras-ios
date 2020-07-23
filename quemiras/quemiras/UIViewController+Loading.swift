//
//  UIViewController+Loading.swift
//  quemiras
//
//  Created by Agustina Markosich on 22/07/2020.
//  Copyright © 2020 Agustina. All rights reserved.
//
import UIKit

class LoadingViewController : UIViewController {
    var activityIndicatorContainerView : UIView?
    var activityIndicatorView : UIActivityIndicatorView?

    public func showActivityIndicator() {
        
        self.activityIndicatorContainerView = UIView()
        activityIndicatorContainerView?.frame = CGRect(x: 0, y: 0, width: 80, height: 80) // Set X and Y whatever you want
        activityIndicatorContainerView?.backgroundColor = .clear

        activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView?.center = self.view.center

        activityIndicatorContainerView?.addSubview(activityIndicatorView!)
        if let activityIndView = activityIndicatorContainerView{
            self.view.addSubview(activityIndView)
            activityIndicatorView?.startAnimating()
        }

        
    }
    
    public func hideActivityIndicartor(){
        activityIndicatorView?.stopAnimating()
        self.activityIndicatorContainerView?.removeFromSuperview()
        
    }
}
