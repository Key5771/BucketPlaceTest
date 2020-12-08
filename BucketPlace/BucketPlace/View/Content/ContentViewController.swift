//
//  ContentViewController.swift
//  BucketPlace
//
//  Created by 김기현 on 2020/12/07.
//

import UIKit

class ContentViewController: UIViewController {
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
    var imageUrl: String?
    var desc: String?
//
//    private var width = Int(UIScreen.main.bounds.width)
//    private var height = Int(UIScreen.main.bounds.height)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        setupUI()
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(_ :)))
        self.view.addGestureRecognizer(pinchRecognizer)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.updateLayout()
        }, completion: nil)
    }
    
    private func setupUI() {
        // contentImageView
        contentImageView.translatesAutoresizingMaskIntoConstraints = false
        contentImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        updateLayout()
        
        // descriptionLabel
        guard let desc = desc else {
            fatalError("desc is nil")
        }
        
        descriptionLabel.text = desc
        descriptionLabel.textColor = .white
        self.view.addSubview(descriptionLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -64).isActive = true
    }
    
    private func updateLayout() {
        let width = self.view.bounds.width
        let height = self.view.bounds.height
        
        // portrait mode
        if width < height {
            let newHeight = height / 3
            
            guard var urlString = imageUrl else { return }
            for _ in 0..<7 {
                urlString.removeLast()
            }
            
            urlString += "\(width)/"
            urlString += "\(newHeight)"
            
            guard let url = URL(string: urlString),
                  let imageData = try? Data(contentsOf: url) else {
                fatalError("Image Data is nil")
            }
            
            contentImageView.image = UIImage(data: imageData)
            self.view.addSubview(contentImageView)
        } else { // landscape mode
            let newWidth = Int(width * CGFloat(16.0 / 9.0))
            
            guard var urlString = imageUrl else { return }
            for _ in 0..<7 {
                urlString.removeLast()
            }
            
            urlString += "\(newWidth)/"
            urlString += "\(height)"
            
            guard let url = URL(string: urlString),
                  let imageData = try? Data(contentsOf: url) else {
                fatalError("Image Data is nil")
            }
            
            contentImageView.image = UIImage(data: imageData)
            self.view.addSubview(contentImageView)
        }
        
        self.view.layoutIfNeeded()
    }
    
    @objc func pinchAction(_ sender: UIPinchGestureRecognizer) {
        contentImageView.transform = contentImageView.transform.scaledBy(x: sender.scale, y: sender.scale)
        
        sender.scale = 1.0
    }
    
    @IBAction func panAction(_ sender: Any) {
        let transition = panGestureRecognizer.translation(in: contentImageView)
        let changedX = contentImageView.center.x + transition.x
        let changedY = contentImageView.center.y + transition.y
        
        contentImageView.center = CGPoint(x: changedX, y: changedY)
        
        UIView.animate(withDuration: 0.2) {
            self.view.isOpaque = true
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        }
        
        panGestureRecognizer.setTranslation(CGPoint.zero, in: contentImageView)
        
        let velocity = panGestureRecognizer.velocity(in: contentImageView)
        if abs(velocity.y) > abs(velocity.x) {
            if abs(contentImageView.center.y - self.view.center.y) > 200 {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        if panGestureRecognizer.state == .ended {
            UIView.animate(withDuration: 0.2) {
                self.view.backgroundColor = .black
                self.contentImageView.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
            }
        }
    }
}
