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
        
        let viewController = ContentViewController()
        let data = contentInfo[indexPath.row]
        viewController.desc = data.description
        viewController.imageUrl = data.image_url
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
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
        
        guard var urlString = infoData.image_url else {
            fatalError()
        }
        for _ in 0..<7 {
            urlString.removeLast()
        }
        
        urlString += "\(Int(UIScreen.main.bounds.width))/"
        urlString += "\(Int(UIScreen.main.bounds.height / 2))"
        guard let url = URL(string: urlString), let imageData = try? Data(contentsOf: url) else {
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

// MARK: - UICollectionViewDelegateFlowLayout
// TODO: - Cell의 사이즈가 내용의 크기에 따라 동적으로 변하도록 해야함
// TODO: - 내용이 많은 경우 이미지가 양옆에서 떨어지는 현상 존재 => 이미지를 불러올 때 사이즈를 지정해주거나, 동적 Cell height를 통해 해결해야 할 듯.
extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height / 1.3)
    }
}
