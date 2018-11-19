//
//  ViewController.swift
//  PanGestureSample
//
//  Created by OuSS on 11/19/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var docImage: UIImageView!
    @IBOutlet weak var trashImage: UIImageView!
    
    var docOrigin: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpPanGesture(view: docImage)
        view.bringSubviewToFront(docImage)
        
        docOrigin = docImage.frame.origin
    }
    
    func setUpPanGesture(view: UIView) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        view.addGestureRecognizer(pan)
    }

    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        guard let docView = sender.view else { return }
        
        switch sender.state {
        case .began, .changed:
            movingDocImage(view: docView, sender: sender)
        case .ended:
            if docView.frame.intersects(trashImage.frame) {
                deleteDocImage()
            } else {
                backDocImageToOrigin()
            }
        default:
            break
        }
    }
    
    func movingDocImage(view: UIView, sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        view.frame.origin = CGPoint(x: view.frame.origin.x + translation.x, y: view.frame.origin.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    func backDocImageToOrigin() {
        UIView.animate(withDuration: 0.3) {
            self.docImage.frame.origin = self.docOrigin
        }
    }
    
    func deleteDocImage() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
           self.docImage.alpha = 0
        }, completion: { (finished) in
            self.trashImage.image = UIImage(named: "Trash")
        })
    }

}

