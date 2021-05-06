//
//  LectureInfo.swift
//  Wandoo_practice
//
//  Created by 최혜린 on 2021/01/28.
//

import UIKit

struct LectureInfo: Codable, Equatable {
    let id: Int
    var name: String
    var date: String
    let numOfLec: String
    var doneNumOfLec: Int
    var isDone: [Bool]
    var memos: [String]
    
    mutating func update(name: String, date: String, isDone: [Bool], doneNumOfLec: Int, memos: [String]) {
        self.name = name
        self.date = date
        self.isDone = isDone
        self.doneNumOfLec = doneNumOfLec
        self.memos = memos
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

class LectureManager {
    static let shared = LectureManager()

    static var lastId: Int = 0

    var lectures: [LectureInfo] = []

    func createLecture(name: String, date: String, numOfLec: String) -> LectureInfo {
        // [x] TODO: create로직 추가
        let nextId = LectureManager.lastId + 1
        LectureManager.lastId = nextId
        let selectedArr = [Bool](repeating: false, count: Int(numOfLec)!)
        let memoArr = [String](repeating: "", count: Int(numOfLec)!)
        return LectureInfo(id: nextId, name: name, date: date, numOfLec: numOfLec, doneNumOfLec: 0, isDone: selectedArr, memos: memoArr)
    }
    
    func updateLec(_ lec: LectureInfo) {
        guard let index = lectures.firstIndex(of: lec) else { return }
        let numOfTrue = lec.isDone.filter{$0}.count
        lectures[index].update(name: lec.name, date: lec.date, isDone: lec.isDone, doneNumOfLec: numOfTrue, memos: lec.memos)
        saveLec()
    }
    
//    func countDone(_ lec: LectureInfo) -> Int {
//        let isDone = lec.isDone
//        let numberOfTrue = isDone.filter{$0}.count
//        return Int(numberOfTrue)
//    }
    
    func addLec(_ lec: LectureInfo) {
        // [x] TODO: add로직 추가
        lectures.append(lec)
        saveLec()
    }

    func deleteLec(_ lec: LectureInfo) {
        lectures = lectures.filter { $0.id != lec.id }
        saveLec()
    }
    
//    func selectedButton(_ lec: LectureInfo, _ idx: Int){
//        var newArr = lec.isDone
//        print(idx)
//        if newArr[idx] == true {
//            newArr[idx] = false
//        } else {
//            newArr[idx] = true
//        }
//        guard let index = lectures.firstIndex(of: lec) else { return }
//        lectures[index].update(isDone: newArr)
//        saveLec()
//        print("썅썅썅....^^")
//    }
//    
//    func updateBtn(_ todo: Todo) {
//        // [x] TODO: updatee 로직 추가
//        guard let index = todos.firstIndex(of: todo) else { return }
//        todos[index].update(isDone: todo.isDone, detail: todo.detail, isToday: todo.isToday)
//        saveTodo()
//    }
//
    func saveLec() {
        Storage.store(lectures, to: .documents, as: "lectures.json")
    }

    func retrieveLec() {
        lectures = Storage.retrive("lectures.json", from: .documents, as: [LectureInfo].self) ?? []

        let lastId = lectures.last?.id ?? 0
        LectureManager.lastId = lastId
    }
}

class DetailViewModel {
    var lecInfo: LectureInfo?
    
    func update(model: LectureInfo?) {
        lecInfo = model
    }
    
    private let manager = LectureManager.shared

    var lectures: [LectureInfo] {
        return manager.lectures
    }
    
//    func changeArr(_ lec: LectureInfo, _ idx: Int) {
//        manager.selectedButton(lec, idx)
//    }
//
//    var todayTodos: [Todo] {
//        return todos.filter { $0.isToday == true }
//    }
//
//    var upcompingTodos: [Todo] {
//        return todos.filter { $0.isToday == false }
//    }
//
//    var numOfSection: Int {
//        return Section.allCases.count
//    }
    
//    func getIndex(_ lec: LectureInfo) {
//        manager.getIndex(lec)
//    }
    
    var numOfLec: Int{
        return lectures.count
    }

    func addLec(_ lec: LectureInfo) {
        manager.addLec(lec)
    }

    func deleteLec(_ lec: LectureInfo) {
        manager.deleteLec(lec)
    }
//
//    func updateTodo(_ todo: Todo) {
//        manager.updateTodo(todo)
//    }
//
    func loadTasks() {
        manager.retrieveLec()
    }
    
    func updateLec(_ lec: LectureInfo) {
        manager.updateLec(lec)
    }
//
//    func countDone(_ lec: LectureInfo) {
//        manager.countDone(lec)
//    }
}
