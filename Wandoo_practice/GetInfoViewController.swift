//
//  GetInfoViewController.swift
//  Wandoo_practice
//
//  Created by 최혜린 on 2021/01/29.
//

import UIKit

class GetInfoViewController: UIViewController {
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var pickDate: UIDatePicker!
    let DidDismissaddViewController: Notification.Name = Notification.Name("DidDismissaddViewController")
    
    let viewModel = DetailViewModel()
    var date: String = ""

    @IBOutlet weak var dateOfLec: UIDatePicker!
    @IBOutlet weak var numOfLec: UITextField!
    @IBOutlet weak var nameOfLec: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func bgTapped(_ sender: Any) {
        numOfLec.resignFirstResponder()
        nameOfLec.resignFirstResponder()
    }
    
    func sendDate(_ sender: UIDatePicker) {
        let datePickerView = sender
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd~"
        date = formatter.string(from: datePickerView.date)
    }
    
    @IBAction func addLectureButtonTapped(_ sender: Any) {
        sendDate(pickDate)
        guard let name = nameOfLec.text, name.isEmpty == false else { return }
        guard let num = numOfLec.text, num.isEmpty == false else {return}
        let lecture = LectureManager.shared.createLecture(name: name, date: date, numOfLec: num)
        viewModel.addLec(lecture)

        NotificationCenter.default.post(name: DidDismissaddViewController, object: nil, userInfo: nil)
        dismiss(animated: true, completion: nil)
    }
}
