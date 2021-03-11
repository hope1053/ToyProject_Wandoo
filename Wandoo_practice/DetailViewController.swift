//
//  DetailViewController.swift
//  Wandoo_practice
//
//  Created by 최혜린 on 2021/01/28.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var lectureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    
    let viewModel = DetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

        // Do any additional setup after loading the view.
    }
    
    func updateUI(){
        if let lecInfo = self.viewModel.lecInfo {
            lectureLabel.text = lecInfo.name
            dateLabel.text = lecInfo.date
            numLabel.text = "\(lecInfo.numoflec)"
        }
    }

    
//    @IBAction func close(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func goBack(_ sender: UIButton) {
        performSegue(withIdentifier: "unwind", sender: nil)
    }
    
}

class DetailViewModel {
    var lecInfo: LectureInfo?
    
    func update(model: LectureInfo?) {
        lecInfo = model
    }
}
