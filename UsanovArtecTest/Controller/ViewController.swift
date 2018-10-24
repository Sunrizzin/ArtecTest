//
//  ViewController.swift
//  UsanovArtecTest
//
//  Created by Алексей Усанов on 23/10/2018.
//  Copyright © 2018 Алексей Усанов. All rights reserved.
//

import UIKit
import RealmSwift
import EmptyDataSet_Swift

class ViewController: UIViewController {
    
    @IBOutlet weak var ibWorkersTableView: UITableView!
    
    var workers = realm.objects(WorkerRLM.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.ibWorkersTableView.reloadData()
    }
    
    private func setupTableView() {
        self.ibWorkersTableView.delegate = self
        self.ibWorkersTableView.dataSource = self
        self.ibWorkersTableView.tableFooterView = UIView()
        self.ibWorkersTableView.emptyDataSetSource = self
        self.ibWorkersTableView.emptyDataSetDelegate = self
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "worker") as! WorkerTableViewCell
        cell.ibWorkerNameLabel.text = "\(self.workers[indexPath.row].name!) \(self.workers[indexPath.row].secondName!)"
        cell.ibWorkerSalaryLabel.text = "\(self.workers[indexPath.row].salary)"
        if self.workers[indexPath.row].salary >= 50000 {
            cell.ibWorkerSalaryLabel.textColor = UIColor.green
        } else if self.workers[indexPath.row].salary < 20000 {
            cell.ibWorkerSalaryLabel.textColor = UIColor.red
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write {
                realm.delete(self.workers[indexPath.row])
            }
            self.ibWorkersTableView.reloadData()
        }
    }
}

extension ViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        let view = UIView(frame: CGRect(x: self.ibWorkersTableView.frame.origin.x , y: self.ibWorkersTableView.frame.origin.y, width: self.view.frame.width, height: self.ibWorkersTableView.frame.height))
        let lb = UILabel(frame: CGRect(x: 15, y: view.frame.height / 2, width: view.bounds.width - 30, height: 100))
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.textColor = UIColor.lightGray
        lb.text = "Добавьте информацию о сотрудниках"
        view.addSubview(lb)
        return view
    }
}
