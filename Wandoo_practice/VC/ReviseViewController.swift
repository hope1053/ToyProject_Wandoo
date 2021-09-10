//
//  ReviseViewController.swift
//  Wandoo_practice
//
//  Created by 최혜린 on 2021/05/04.
//

import UIKit

class ReviseViewController: UIViewController {
    var feedbackGenerator: UINotificationFeedbackGenerator?

    @IBOutlet var reviseView: UIView!
    @IBOutlet weak var numberOfLec: UITextField!
    @IBOutlet weak var startedDate: UIDatePicker!
    @IBOutlet weak var nameOfLec: UITextField!
    let viewModel = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        nameOfLec.delegate = self
        self.setupGenerator()
    }
    
    private func setupGenerator() {
        self.feedbackGenerator = UINotificationFeedbackGenerator()
        self.feedbackGenerator?.prepare()
    }
    
    let DidDismissReviseViewController: Notification.Name = Notification.Name("DidDismissReviseViewController")
    
    var date: String = ""
    
    func updateUI() {
        if let lecInfo = viewModel.lecInfo {
            nameOfLec.text = lecInfo.name
            startedDate.setDate(stringToDate(date: lecInfo.date), animated: true)
            numberOfLec.text = lecInfo.numOfLec
        }
    }
    
    @IBAction func tappedBG(_ sender: Any) {
        nameOfLec.resignFirstResponder()
        startedDate.resignFirstResponder()
        numberOfLec.resignFirstResponder()
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
        
        let revisedNumOfLec: Int = Int(numberOfLec.text!)!
        let originNumOfLec: Int = Int(viewModel.lecInfo!.numOfLec)!
        
        if revisedNumOfLec < originNumOfLec {
            let alert = UIAlertController(title: "잠시만요!", message: "입력된 강의수가 기존 강의수보다 적습니다. 이런 경우 범위를 벗어난 메모는 삭제됩니다. 계속 진행하시겠습니까?", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "네!", style: .default) { (action) in
                self.viewModel.lecInfo?.numOfLec = self.numberOfLec.text!
                self.viewModel.lecInfo = self.viewModel.reviseLec(self.viewModel.lecInfo!)
                self.viewModel.updateLec(self.viewModel.lecInfo!)
                
                NotificationCenter.default.post(name: self.DidDismissReviseViewController, object: self.viewModel.lecInfo)
                self.dismiss(animated: true, completion: nil)
            }
            
            let cancelAction = UIAlertAction(title:"아니요", style: .cancel)
            
            alert.addAction(OKAction)
            alert.addAction(cancelAction)
            self.feedbackGenerator?.notificationOccurred(.warning)
            present(alert, animated: true, completion: nil)
        } else {
            viewModel.lecInfo?.numOfLec = numberOfLec.text!
            viewModel.lecInfo = viewModel.reviseLec(viewModel.lecInfo!)
            viewModel.updateLec(viewModel.lecInfo!)
            NotificationCenter.default.post(name: DidDismissReviseViewController, object: viewModel.lecInfo)
            dismiss(animated: true, completion: nil)
        }
    }
}

extension ReviseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.reviseView.endEditing(true)
        return true
    }
}
