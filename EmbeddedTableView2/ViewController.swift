//
//  ViewController.swift
//  EmbeddedTableView1
//
//  Created by Pavel Kazantsev on 3/26/17.
//  Copyright © 2017 PaKaz.net. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var embeddedTableViewRows = ["London", "New York", "Amsterdam"]

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = editButtonItem
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        tableView.beginUpdates()
        tableView.endUpdates()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "Simple1", for: indexPath)
        }
        else if indexPath.section == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "Simple2", for: indexPath)
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "EmbeddedCell", for: indexPath)
            let embeddedCell = cell as! EmbeddedTableViewCell
            embeddedCell.rows = embeddedTableViewRows
            embeddedCell.rowsChangedCallback = { [weak self] operation, text in
                guard let `self` = self else { return }

                self.tableView.beginUpdates()
                switch operation {
                case .insert(let indexPath):
                    self.embeddedTableViewRows.insert(text, at: indexPath.row)
                case .delete(let indexPath):
                    self.embeddedTableViewRows.remove(at: indexPath.row)
                }
                self.tableView.endUpdates()
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            var rowsCount = embeddedTableViewRows.count
            if isEditing {
                rowsCount += 1
            }
            return CGFloat(44 * rowsCount)
        }
        return 44
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt: \(indexPath)")
    }
}

