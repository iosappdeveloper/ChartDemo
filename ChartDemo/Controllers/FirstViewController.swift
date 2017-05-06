//
//  FirstViewController.swift
//  ChartDemo
//
//  Created by Matoria, Ashok on 5/3/17.
//  Copyright © 2017 Matoria, Ashok. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    fileprivate let minimumRowHeight = CGFloat(140)
    fileprivate let chartCellId = String(describing: ChartTableViewCell.self)
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }
    func registerCells() {
        tableView.register(UINib(nibName: chartCellId, bundle: nil), forCellReuseIdentifier: chartCellId)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.bounds.maxY > 3*minimumRowHeight {
            tableView.rowHeight = minimumRowHeight + (view.bounds.maxY - 3*minimumRowHeight)/4
        } else {
            tableView.rowHeight = minimumRowHeight
        }
        tableView.reloadData()
    }
}

// MARK: UITableViewDataSource
extension FirstViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: chartCellId, for: indexPath) as! ChartTableViewCell
        return cell
    }
}
// MARK: UITableViewDelegate
extension FirstViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//    }
//    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//    }
//    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        
//    }
}
