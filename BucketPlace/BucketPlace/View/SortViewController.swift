//
//  SortViewController.swift
//  BucketPlace
//
//  Created by 김기현 on 2020/12/08.
//

import UIKit

class SortViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var sortTitle: String = ""
    var sortArr: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .clear
        setUpTableView()
        
        headerContainerView.layer.borderColor = UIColor.black.cgColor
        headerContainerView.backgroundColor = .white
        
        categoryLabel.text = sortTitle
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibName = UINib(nibName: "SortTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "sortCell")
    }
    
    @IBAction func tapAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SortViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath: \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SortViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "sortCell", for: indexPath) as? SortTableViewCell else {
            return UITableViewCell()
        }
        
        cell.sortLabel.text = sortArr[indexPath.row]
        
        self.tableView.tableFooterView = UIView()
        
        return cell
    }
}


