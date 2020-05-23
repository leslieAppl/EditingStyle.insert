//
//  EmbeddedTableViewCell.swift
//  EmbeddedTableView1
//
//  Created by Pavel Kazantsev on 3/27/17.
//  Copyright © 2017 PaKaz.net. All rights reserved.
//

import UIKit

class EmbeddedTableViewCell: UITableViewCell {

    @IBOutlet weak var tableView: UITableView!

    var rows: [String] = []

    enum Operation {
        case insert(IndexPath)
        case delete(IndexPath)
    }

    var rowsChangedCallback: ((Operation, String) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        tableView.dataSource = self
        tableView.delegate = self
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        let wasEditing = isEditing

        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)

        if wasEditing != editing {
            let indexPath = IndexPath(row: rows.count, section: 0)
            if editing {
                tableView.insertRows(at: [indexPath], with: .top)
            } else {
                tableView.deleteRows(at: [indexPath], with: .top)
            }
        }
    }

}

extension EmbeddedTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowsCount = rows.count
        if isEditing {
            rowsCount += 1
        }
        return rowsCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == rows.count && isEditing {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmbeddedTableViewCellInsert", for: indexPath)
            cell.textLabel?.text = "Add a row"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmbeddedTableViewCell", for: indexPath)
            cell.textLabel?.text = rows[indexPath.row]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let text = rows[indexPath.row]
            rows.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .top)
            rowsChangedCallback?(.delete(indexPath), text)
        } else if editingStyle == .insert {
            let text = "A New Row #\(indexPath.row)"
//            let newIndexPath = IndexPath(row: rows.count, section: 0)
            rows.append(text)
//            tableView.insertRows(at: [newIndexPath], with: .top)
            rowsChangedCallback?(.insert(indexPath), text)
        }
        
        tableView.reloadData()
    }
}

extension EmbeddedTableViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.row == rows.count {
            return .insert
        }
        return .delete
    }
}
