//
//  ListViewController.swift
//  BucketPlace
//
//  Created by 김기현 on 2020/12/06.
//

import UIKit

class ListViewController: UIViewController {

    let baseUrl = "https://s3.ap-northeast-2.amazonaws.com/bucketplace-coding-test/cards/page_1.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("hello world")
        NetworkRequest.shared.getData(baseUrl: baseUrl) { (response: [ListAPI]) in
            print("response: \(response)")
        }
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
