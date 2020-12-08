//
//  ListViewController.swift
//  BucketPlace
//
//  Created by 김기현 on 2020/12/06.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var spaceView: UIView!
    @IBOutlet weak var residenceView: UIView!
    
    var baseUrl = "https://s3.ap-northeast-2.amazonaws.com/bucketplace-coding-test/cards/page_1.json"
    var contentInfo: [ListAPI] = []
    let flowLayout = UICollectionViewFlowLayout()
    
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
        // collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
        let nibName = UINib(nibName: "ListCollectionViewCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "ListCollectionViewItem")
        
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        // sortButton View
        orderView.layer.cornerRadius = 4
        spaceView.layer.cornerRadius = 4
        residenceView.layer.cornerRadius = 4
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
        }, completion: nil)
    }
    
    @IBAction func orderAction(_ sender: Any) {
        print("order sort")
        let vc = SortViewController()
        let order = Order()
        vc.sortTitle = order.sortName.0
        vc.sortArr = [order.recent.0, order.best.0, order.popular.0]
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func spaceAction(_ sender: Any) {
        print("space order")
        let vc = SortViewController()
        let space = Space()
        vc.sortTitle = space.sortName.0
        vc.sortArr = [space.livingroom.0, space.bedroom.0, space.kitchen.0, space.bathroom.0]
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func residenceAction(_ sender: Any) {
        print("residence order")
        let vc = SortViewController()
        let residence = Residence()
        vc.sortTitle = residence.sortName.0
        vc.sortArr = [residence.apartment.0, residence.villa.0, residence.house.0, residence.office.0]
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
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
        viewController.modalPresentationStyle = .custom
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
        
        urlString += "\(Int(self.collectionView.bounds.width))/"
        urlString += "\(Int(self.collectionView.bounds.height / 2))"
        
        DispatchQueue.global().async {
            guard let url = URL(string: urlString), let imageData = try? Data(contentsOf: url) else {
                fatalError("imageURL is nil")
            }
            
            DispatchQueue.main.async {
                item.imageView.image = UIImage(data: imageData)
            }
        }
        
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
        let sectionInset = flowLayout.sectionInset
        let referenceHeight: CGFloat = 500
        let referenceWidth = self.view.frame.width
                    - sectionInset.left
                    - sectionInset.right
                    - collectionView.contentInset.left
                    - collectionView.contentInset.right
        return CGSize(width: referenceWidth, height: referenceHeight)
    }
}
