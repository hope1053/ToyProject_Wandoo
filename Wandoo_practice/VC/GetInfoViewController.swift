//
//  GetInfoViewController.swift
//  Wandoo_practice
//
//  Created by 최혜린 on 2021/01/29.
//

import UIKit

class GetInfoViewController: UIViewController {
    
    @IBOutlet weak var createLabel: UILabel!
    @IBOutlet var getInfoview: UIView!
    @IBOutlet weak var warningMessage: UILabel!
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
        warningMessage.alpha = 0
        nameOfLec.delegate = self
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
        if Int(num)! >= 100 {
            numOfLec.textColor = #colorLiteral(red: 1, green: 0.3091483116, blue: 0.2951850593, alpha: 1)
            warningMessage.alpha = 1
            createLabel.shake(duration: 0.5)
            createButton.shake(duration: 0.5)
            return
        }
        let lecture = LectureManager.shared.createLecture(name: name, date: date, numOfLec: num)
        viewModel.addLec(lecture)

        NotificationCenter.default.post(name: DidDismissaddViewController, object: nil, userInfo: nil)
        dismiss(animated: true, completion: nil)
    }
}

extension GetInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ nameOfLec: UITextField) -> Bool {
            self.getInfoview.endEditing(true)
            return true
    }
}

extension UIView {
    func shake(duration: CFTimeInterval) {
        let shakeValues = [-5, 5, -5, 5, -3, 3, -2, 2, 0]

        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");
        translation.timingFunction = CAMediaTimingFunction(name: .linear)
        translation.values = shakeValues
        
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.values = shakeValues.map { (Int(Double.pi) * $0) / 180 }
        
        let shakeGroup = CAAnimationGroup()
        shakeGroup.animations = [translation, rotation]
        shakeGroup.duration = 1.0
        layer.add(shakeGroup, forKey: "shakeIt")
    }
}
