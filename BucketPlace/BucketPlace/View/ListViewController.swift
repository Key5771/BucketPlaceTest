//
//  ListViewController.swift
//  BucketPlace
//
//  Created by 김기현 on 2020/12/06.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var baseUrl = "https://s3.ap-northeast-2.amazonaws.com/bucketplace-coding-test/cards/page_1.json"
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
        collectionView.prefetchDataSource = self
        
        let nibName = UINib(nibName: "ListCollectionViewCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "ListCollectionViewItem")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
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

// MARK: - UICollectionViewDelegate
extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("indexPath: \(indexPath.row)")
    }
}

// MARK: - UICollectionViewDataSource
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
        guard let urlString = infoData.image_url, let url = URL(string: urlString), let imageData = try? Data(contentsOf: url) else {
            fatalError("imageURL is nil")
        }
        item.imageView.image = UIImage(data: imageData)
        
        return item
    }
}

// MARK: - UICollectionViewDataSourcePrefetching : 리스트 하단에 도착하면 같은 데이터 조회하여 collectionView reloadData
extension ListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        dataLoad(indexpaths: indexPaths)
    }
    
    private func dataLoad(indexpaths: [IndexPath]) {
        guard let lastIndex = indexpaths.last?.item, lastIndex >= contentInfo.count - 1 else { return }
        NetworkRequest.shared.getData(baseUrl: baseUrl) { (response: [ListAPI]) in
            self.contentInfo.append(contentsOf: response)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height / 1.3)
    }
}
