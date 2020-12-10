//
//  ListViewController.swift
//  BucketPlace
//
//  Created by 김기현 on 2020/12/06.
//

import UIKit

class ListViewController: UIViewController {
    // MARK: - Outlet 관련 변수
    @IBOutlet weak var listCollectionView: UICollectionView!
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var spaceView: UIView!
    @IBOutlet weak var residenceView: UIView!
    @IBOutlet weak var sortCollectionView: UICollectionView!
    
    // Variable
    var baseUrl = "https://s3.ap-northeast-2.amazonaws.com/bucketplace-coding-test/cards/page_1.json"
    var contentInfo: [ListAPI] = []
    var filterInfo: [(String, (paramName: String, value: String))] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Data Load
        loadData()
        
        // UI Setting
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !filterInfo.isEmpty {
            sortCollectionView.reloadData()
            loadData()
            listCollectionView.reloadData()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.listCollectionView.collectionViewLayout.invalidateLayout()
        coordinator.animate(alongsideTransition: { _ in
            self.listCollectionView.reloadData()
        }, completion: nil)
    }
    
    private func setupUI() {
        // collectionView
        listCollectionView.delegate = self
        listCollectionView.dataSource = self
        listCollectionView.prefetchDataSource = self
        
        let nibName = UINib(nibName: "ListCollectionViewCell", bundle: nil)
        listCollectionView.register(nibName, forCellWithReuseIdentifier: "ListCollectionViewItem")
        
        let listFlowLayout = UICollectionViewFlowLayout()
        listFlowLayout.sectionInset = .zero
        listFlowLayout.invalidateLayout()
        self.listCollectionView.collectionViewLayout = listFlowLayout
        
        // sortCollectionView
        sortCollectionView.delegate = self
        sortCollectionView.dataSource = self
        
        let sortNibName = UINib(nibName: "SortCollectionViewCell", bundle: nil)
        sortCollectionView.register(sortNibName, forCellWithReuseIdentifier: "sortNameItem")
        
        let sortFlowLayout = UICollectionViewFlowLayout()
        sortFlowLayout.sectionInset = UIEdgeInsets(top: 7, left: 16, bottom: 7, right: 0)
        sortFlowLayout.minimumInteritemSpacing = 4
        self.sortCollectionView.collectionViewLayout = sortFlowLayout
        
        // sortButton View
        orderView.layer.cornerRadius = 4
        spaceView.layer.cornerRadius = 4
        residenceView.layer.cornerRadius = 4
        
    }
    
    private func loadData() {
        if filterInfo.isEmpty {
            NetworkRequest.shared.getData(baseUrl: baseUrl) { (response: [ListAPI]) in
                if self.contentInfo.isEmpty {
                    self.contentInfo = response
                } else {
                    self.contentInfo.append(contentsOf: response)
                }
                
                DispatchQueue.main.async {
                    self.listCollectionView.reloadData()
                }
            }
        } else {
            var queryItem = [URLQueryItem]()
            for i in 0..<filterInfo.count {
                let key = filterInfo[i].1.paramName
                let value = filterInfo[i].1.value

                queryItem.append(URLQueryItem(name: key, value: value))
            }
            
            NetworkRequest.shared.getData(baseUrl: baseUrl, params: queryItem) { (response: [ListAPI]) in
                if self.contentInfo.isEmpty {
                    self.contentInfo = response
                } else {
                    self.contentInfo.append(contentsOf: response)
                }
                
                DispatchQueue.main.async {
                    self.listCollectionView.reloadData()
                }
            }
        }
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
            
            // 이미지 데이터가 1:1이고 데이터타입으로 만들어 이미지를 보여주기 때문에 그때그때마다 사이즈 다르게 호출
            // 좀 더 좋은 방법을 생각해봐야할 듯.
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
        guard let lastIndex = indexPaths.last?.item, lastIndex >= contentInfo.count - 3 else { return }
        loadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == sortCollectionView {
            let width: CGFloat = 90
            let height: CGFloat = 26
            return CGSize(width: width, height: height)
        }
        
        let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let referenceHeight: CGFloat = collectionView.frame.height * 0.9
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
    func passData(data: (String, (paramName: String, value: String))) {
        if !filterInfo.contains(where: { (result) -> Bool in
            if result.1.0 != data.1.paramName {
                return false
            }
            
            return true
        }) {
            filterInfo.append(data)
        } else {
            if let index = filterInfo.firstIndex(where: { (result) -> Bool in
                if result.1.0 == data.1.paramName {
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
