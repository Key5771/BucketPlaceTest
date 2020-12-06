//
//  ListViewController.swift
//  BucketPlace
//
//  Created by 김기현 on 2020/12/06.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let baseUrl = "https://s3.ap-northeast-2.amazonaws.com/bucketplace-coding-test/cards/page_1.json"
    var contentInfo: [ListAPI] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        NetworkRequest.shared.getData(baseUrl: baseUrl) { (response: [ListAPI]) in
            self.contentInfo = response
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nibName = UINib(nibName: "ListCollectionViewCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "ListCollectionViewItem")
    }
    
    @IBAction func orderAction(_ sender: Any) {
        print("order sort")
    }
    
    @IBAction func spaceAction(_ sender: Any) {
        print("space order")
    }
    
    @IBAction func residenceAction(_ sender: Any) {
        print("residence order")
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("indexPath: \(indexPath.row)")
    }
}

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionViewItem", for: indexPath) as? ListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let infoData = contentInfo[indexPath.row]
        
        item.descriptionLabel.text = infoData.description
        guard let urlString = infoData.image_url, let url = URL(string: urlString) else {
            fatalError("imageURL is nil")
        }
        
        guard let imageData = try? Data(contentsOf: url) else {
            fatalError()
        }
        item.imageView.image = UIImage(data: imageData)
        
        return item
    }
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height / 1.5)
    }
}
