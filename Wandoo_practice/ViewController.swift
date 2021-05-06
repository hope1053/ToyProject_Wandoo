//
//  ViewController.swift
//  Wandoo_practice
//
//  Created by 최혜린 on 2021/01/27.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var lectureTable: UITableView!
    let viewModel = DetailViewModel()
    
    @IBAction func unwind(_ segue: UIStoryboardSegue){
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadTasks()
        showLable()
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissaddNotification(_:)), name: NSNotification.Name(rawValue: "DidDismissaddViewController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissDetailNotification(_:)), name: NSNotification.Name(rawValue: "DidDismissaDetailViewController"), object: nil)
    }
    
    func showLable() {
        if viewModel.numOfLec == 0 {
            noResultLabel.alpha = 0.5
        } else {
            noResultLabel.alpha = 0
        }
    }
    
    @objc func didDismissaddNotification(_ noti: Notification) {
            OperationQueue.main.addOperation { // DispatchQueue도 가능.
                self.lectureTable.reloadData()
                self.viewModel.loadTasks()
                self.showLable()
            }
    }
    
    @objc func didDismissDetailNotification(_ noti: Notification) {
            OperationQueue.main.addOperation { // DispatchQueue도 가능.
                self.lectureTable.reloadData()
                self.viewModel.loadTasks()
                self.showLable()
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as? DetailViewController
            if let index = sender as? Int {
                let lecInfo = viewModel.lectures[index]
                vc?.viewModel.update(model: lecInfo)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numOfLec
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListCell else{
            return UITableViewCell()
        }
        let lecture = viewModel.lectures[indexPath.row]
        let viewWidth = mainView.bounds.width
        cell.updateUI(info: lecture, width: viewWidth)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            viewModel.deleteLec(viewModel.lectures[indexPath.item])
            lectureTable.reloadData()
            showLable()
        }
    }
    
    @IBAction func getInfo(_ sender: Any) {
        performSegue(withIdentifier: "getInfo", sender: nil)
    }
    
    
}

class ListCell: UITableViewCell {
    @IBOutlet weak var lectureLabel: UILabel!
    @IBOutlet weak var bgBar: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var doneNumofLec: UILabel!
    
    @IBOutlet weak var progressWidth: NSLayoutConstraint!
    
    func updateUI(info: LectureInfo, width: CGFloat){
        lectureLabel.text = info.name
        dateLabel.text = info.date
        numLabel.text = "\(info.numOfLec)"
        progressBar.layer.cornerRadius = 9
        bgBar.layer.cornerRadius = 9
        doneNumofLec.text = String(info.isDone.filter{$0}.count)
        let numOfTrue = Double(info.doneNumOfLec) / Double(info.numOfLec)!
        progressWidth.constant = (width - 40) * (0.05 + 0.95 * CGFloat(numOfTrue))
    }
}
