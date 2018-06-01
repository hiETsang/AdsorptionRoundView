//
//  ViewController.swift
//  AdsorptionRoundView
//
//  Created by canoe on 2018/6/1.
//  Copyright © 2018年 canoe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var roundView : UIImageView!
    var animator : UIDynamicAnimator!
    var behavior : UIAttachmentBehavior?        //吸附效果
    var snapBehavior : UISnapBehavior?          //旋转效果
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configUI()
        configAnimator()
        configGesture()
    }
    
    
    func configUI() {
        let backImageView = UIImageView(image: UIImage(named: "Artboard"))
        view.addSubview(backImageView)
        
        roundView = UIImageView(image: UIImage(named:"avatar"))
        view.addSubview(roundView)
        roundView.frame = CGRect(x: 0, y: 0, width: 110, height: 110)
        roundView.center = CGPoint(x: view.center.x, y: 225)
        roundView.isUserInteractionEnabled = true
        
        roundView.layer.shadowColor = UIColor.black.cgColor
        roundView.layer.shadowOffset = CGSize.zero
        roundView.layer.shadowOpacity = 0.1
        roundView.layer.shadowRadius = 15
        
    }
    
    
    func configAnimator() {
        animator = UIDynamicAnimator(referenceView: view)

        //回弹
        snapBehavior = UISnapBehavior(item: roundView, snapTo: roundView.convert(CGPoint(x: roundView.bounds.size.width/2.0, y: roundView.bounds.size.height/2.0), to: view))
        //阻尼
        snapBehavior?.damping = 0.3
    }
    
    
    func configGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(panGestrue:)))
        roundView.addGestureRecognizer(pan)
    }
    
    @objc func pan(panGestrue:UIPanGestureRecognizer) {
        switch panGestrue.state {
        case .began:
            beginPanGesture(withPanRecognizer: panGestrue)
           case .changed:
            changedPanGesture(withPanRecognizer: panGestrue)
            case .ended,.cancelled,.failed:
            endPanGesture(withPanRecognizer: panGestrue)
        default:
            break
        }
    }
    
    func beginPanGesture(withPanRecognizer panRecognizer: UIPanGestureRecognizer) {
        animator.removeAllBehaviors()
        
        let location = panRecognizer.location(in: view)
        let convertCenter = roundView.convert(CGPoint(x: roundView.bounds.size.width/2.0, y: roundView.bounds.size.height/2.0), to: self.view)
        let offset = UIOffsetMake(location.x - convertCenter.x, location.y - convertCenter.y)
        
        //吸附效果
        behavior = UIAttachmentBehavior(item: roundView, offsetFromCenter: offset, attachedToAnchor: location)
        animator.addBehavior(behavior!)
    }
    
    func changedPanGesture(withPanRecognizer panRecognizer: UIPanGestureRecognizer) {
        let location = panRecognizer.location(in: view)
        behavior?.anchorPoint = location
    }

    func endPanGesture(withPanRecognizer panRecognizer: UIPanGestureRecognizer) {
        animator.removeAllBehaviors()
        animator.addBehavior(snapBehavior!)
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

