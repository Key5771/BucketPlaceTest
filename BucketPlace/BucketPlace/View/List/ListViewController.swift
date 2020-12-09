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
    @IBOutlet weak var sortCollectionView: UICollectionView!
    
    var baseUrl = "https://s3.ap-northeast-2.amazonaws.com/bucketplace-coding-test/cards/page_1.json"
    var contentInfo: [ListAPI] = []
    var filterInfo: [(String, (String, String))] = []
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        print("filterInfo: \(filterInfo)")
        
        sortCollectionView.reloadData()
    }
    
    private func setupUI() {
        // collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
        let nibName = UINib(nibName: "ListCollectionViewCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "ListCollectionViewItem")
        
        
        // sortCollectionView
        sortCollectionView.delegate = self
        sortCollectionView.dataSource = self
        
        let sortNibName = UINib(nibName: "SortCollectionViewCell", bundle: nil)
        sortCollectionView.register(sortNibName, forCellWithReuseIdentifier: "sortNameItem")
        
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
        let vc = SortViewController()
        
        guard let button = sender as? UIButton else { return }
        if button.tag == 1 {
            let order = Order()
            vc.sortTitle = order.sortName.0
            vc.sortArr = [order.recent, order.best, order.popular]
            vc.type = order
        } else if button.tag == 2 {
            let space = Space()
            vc.sortTitle = space.sortName.0
            vc.sortArr = [space.livingroom, space.bedroom, space.bathroom, space.kitchen]
            vc.type = space
        } else {
            let residence = Residence()
            vc.sortTitle = residence.sortName.0
            vc.sortArr = [residence.apartment, residence.villa, residence.house, residence.office]
            vc.type = residence
        }
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate
extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == sortCollectionView {
            filterInfo.remove(at: indexPath.row)
            sortCollectionView.reloadData()
        } else {
            print("indexPath: \(indexPath.row)")
            
            let viewController = ContentViewController()
            let data = contentInfo[indexPath.row]
            viewController.desc = data.description
            viewController.imageUrl = data.image_url
            viewController.modalPresentationStyle = .custom
            self.present(viewController, animated: true, completion: nil)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sortCollectionView {
            return filterInfo.count
        }
        return contentInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sortCollectionView {
            guard let sortItem = collectionView.dequeueReusableCell(withReuseIdentifier: "sortNameItem", for: indexPath) as? SortCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let filter = filterInfo[indexPath.row].0
            
            sortItem.sortNameLabel.text = filter
            
            return sortItem
        } else {
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
            
            urlString += "\(Int(self.view.bounds.width))/"
            urlString += "\(Int(self.view.bounds.height / 2))"
            
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
        if collectionView == sortCollectionView {
            return CGSize(width: 80, height: 26)
        }
        
        let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let referenceHeight: CGFloat = collectionView.frame.height * 0.8
        let referenceWidth = collectionView.frame.width
                    - sectionInset.left
                    - sectionInset.right
                    - collectionView.contentInset.left
                    - collectionView.contentInset.right
        return CGSize(width: referenceWidth, height: referenceHeight)
    }
}

extension ListViewController: PassDataDelegate {
    // order, space, residence에 해당하는 값 하나만을 갖기 위한 알고리즘.
    func passData(data: (String, (String, String))) {
        if !filterInfo.contains(where: { (result) -> Bool in
            if result.1.0 != data.1.0 {
                return false
            }
            
            return true
        }) {
            filterInfo.append(data)
        } else {
            if let index = filterInfo.firstIndex(where: { (result) -> Bool in
                if result.1.0 == data.1.0 {
                    return true
                }
                
                return false
            }) {
                filterInfo.remove(at: index)
                filterInfo.append(data)
            }
        }
    }
}
