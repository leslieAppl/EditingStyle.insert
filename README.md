# Adding and removing rows with EditingStyle.insert and .delete
### SOURCE: https://pakaz.wordpress.com/2017/04/06/tutorial-adding-and-removing-rows/

        if editingStyle == .delete {
            let text = rows[indexPath.row]
            rows.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
            rowsChangedCallback?(.delete(indexPath), text)
        } else if editingStyle == .insert {
            let text = "A New Row #\(indexPath.row)"
            let newIndexPath = IndexPath(row: rows.count, section: 0)
            rows.append(text)
            tableView.insertRows(at: [newIndexPath], with: .top)
            rowsChangedCallback?(.insert(indexPath), text)
        }
