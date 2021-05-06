//
//  ReviseViewController.swift
//  Wandoo_practice
//
//  Created by 최혜린 on 2021/05/04.
//

import UIKit

class ReviseViewController: UIViewController {

    @IBOutlet weak var startedDate: UIDatePicker!
    @IBOutlet weak var nameOfLec: UITextField!
    let viewModel = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    let DidDismissReviseViewController: Notification.Name = Notification.Name("DidDismissReviseViewController")
    
    var date: String = ""
    
    func updateUI() {
        if let lecInfo = viewModel.lecInfo {
            nameOfLec.text = lecInfo.name
            startedDate.setDate(stringToDate(date: lecInfo.date), animated: true)
        }
    }
    
    @IBAction func tappedBG(_ sender: Any) {
        nameOfLec.resignFirstResponder()
        startedDate.resignFirstResponder()
    }
    
    func stringToDate(date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd~"
        let date = formatter.date(from: date)
        return date!
    }
    
    func dateToString(_ sender: UIDatePicker) {
        let datePickerView = sender
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd~"
        date = formatter.string(from: datePickerView.date)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        dateToString(startedDate)
        viewModel.lecInfo?.name = nameOfLec.text!
        viewModel.lecInfo?.date = date
        viewModel.updateLec(viewModel.lecInfo!)
        print(viewModel.lectures)

        NotificationCenter.default.post(name: DidDismissReviseViewController, object: viewModel.lecInfo)
        dismiss(animated: true, completion: nil)
    }
}
