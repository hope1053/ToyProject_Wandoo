//
//  DetailViewController.swift
//  Wandoo_practice
//
//  Created by 최혜린 on 2021/01/28.
//

import UIKit

class DetailViewController: UIViewController {
    
    let DidDismissaDetailViewController: Notification.Name = Notification.Name("DidDismissaDetailViewController")
    
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    @IBOutlet var detailView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lectureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var doneLecNum: UILabel!
    
    @IBOutlet weak var progessWidth: NSLayoutConstraint!
    
    let viewModel = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissReviseNotification(_:)), name: NSNotification.Name(rawValue: "DidDismissReviseViewController"), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reviseSegue" {
            let vc = segue.destination as? ReviseViewController
            if let lecInfo = sender as? LectureInfo {
                vc?.viewModel.update(model: lecInfo)
            }
        }
    }

    @objc func didDismissReviseNotification(_ noti: Notification) {
            OperationQueue.main.addOperation { // DispatchQueue도 가능.
                let newViewInfo = noti.object as? LectureInfo
                self.tableView.reloadData()
                self.viewModel.loadTasks()
                self.viewModel.update(model: newViewInfo)
                self.updateUI()
            }
    }
    
    func updateUI(){
        if let lecInfo = self.viewModel.lecInfo {
            lectureLabel.text = lecInfo.name
            dateLabel.text = lecInfo.date
            numLabel.text = "\(lecInfo.numOfLec)"
            progressBar.layer.cornerRadius = 10
            doneLecNum.text = String(lecInfo.isDone.filter{$0}.count)
            let numOfTrue = Double(lecInfo.doneNumOfLec) / Double(lecInfo.numOfLec)!
            progessWidth.constant = (detailView.bounds.width - 60) * (0.05 + 0.95 * CGFloat(numOfTrue))
        }
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        performSegue(withIdentifier: "unwind", sender: nil)
        NotificationCenter.default.post(name: DidDismissaDetailViewController, object: nil, userInfo: nil)
    }
    
    @IBAction func swipeLeftGesture(_ sender: Any) {
        performSegue(withIdentifier: "unwind", sender: nil)
        NotificationCenter.default.post(name: DidDismissaDetailViewController, object: nil, userInfo: nil)
    }
    
    // 해당 강의 관련 내용 수정 및 삭제 alerty dialog 구현
    @IBAction func makeAlertDialog(_ sender: UIButton) {
        let alert = UIAlertController(title: viewModel.lecInfo?.name, message: nil, preferredStyle: .actionSheet)
        
        let lecture: LectureInfo = viewModel.lecInfo!
        
        let deleteBtn = UIAlertAction(title: "삭제", style: .destructive) { (action) in
            self.viewModel.deleteLec(lecture)
            NotificationCenter.default.post(name: self.DidDismissaDetailViewController, object: nil, userInfo: nil)
            self.performSegue(withIdentifier: "unwind", sender: nil)
        }
        let reviseBtn = UIAlertAction(title: "수정", style: .default) { (action) in
            self.performSegue(withIdentifier: "reviseSegue", sender: self.viewModel.lecInfo)
        }
        
        alert.addAction(reviseBtn)
        alert.addAction(deleteBtn)
        
        self.present(alert, animated: true, completion: {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
            alert.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        })
    }
    
    @objc func dismissAlertController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(viewModel.lecInfo!.numOfLec)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "checkCell", for: indexPath) as? checkLecture else {
            return UITableViewCell()
        }
        cell.num.text = String(indexPath.item + 1) + "강"
        var lecture = viewModel.lecInfo!
        cell.updateUI(lecture, indexPath.item)
        
        cell.doneButtonTapHandler = { isTapped in
            lecture.isDone[indexPath.item] = isTapped
            lecture.doneNumOfLec = lecture.isDone.filter{$0}.count
            self.viewModel.updateLec(lecture)
            self.viewModel.update(model: lecture)
            self.tableView.reloadData()
            
            self.doneLecNum.text = String(lecture.isDone.filter{$0}.count)
            let numOfTrue = Double(lecture.doneNumOfLec) / Double(lecture.numOfLec)!
            self.progessWidth.constant = (self.detailView.bounds.width - 60) * (0.05 + 0.95 * CGFloat(numOfTrue))
        }
        cell.saveMemoHandler = { text in
            lecture.memos[indexPath.item] = text
            self.viewModel.updateLec(lecture)
            self.viewModel.update(model: lecture)
            self.tableView.reloadData()
        }
        return cell
    }
}

extension DetailViewController {
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            tableViewBottom.constant = adjustmentHeight
        } else {
            tableViewBottom.constant = 0
        }
    }
}

class checkLecture: UITableViewCell {
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    
    var doneButtonTapHandler: ((Bool) -> Void)?
    var saveMemoHandler: ((String) -> Void)?
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        doneButton.isSelected = !doneButton.isSelected
        let isTapped = doneButton.isSelected
        doneButtonTapHandler?(isTapped)
    }
    
    @IBAction func memoAdded(_ sender: Any) {
        if inputTextField.text != nil {
            saveMemoHandler?(inputTextField.text!)
        }
    }
    
    func updateUI(_ lec: LectureInfo, _ idx: Int){
        doneButton.isSelected = lec.isDone[idx]
        inputTextField.text = lec.memos[idx]
    }
}
