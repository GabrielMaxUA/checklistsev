//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Max Gabriel on 2024-06-10.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {
    let cellIdentifier = "ChecklistCell"
    var dataModel: DataModel!

    override func viewDidLoad() {
      super.viewDidLoad()
      navigationController?.navigationBar.prefersLargeTitles = true
      tableView.register(
        UITableViewCell.self,
        forCellReuseIdentifier: cellIdentifier)
    }

    
    // MARK: - List Detail View Controller Delegates
    func listDetailViewControllerDidCancel(
      _ controller: ListDetailViewController
    ) {
      navigationController?.popViewController(animated: true)
    }

    func listDetailViewController(
      _ controller: ListDetailViewController,
      didFinishAdding checklist: Checklist
    ) {
        let newRowIndex = dataModel.lists.count
        dataModel.lists.append(checklist)

      let indexPath = IndexPath(row: newRowIndex, section: 0)
      let indexPaths = [indexPath]
      tableView.insertRows(at: indexPaths, with: .automatic)

      navigationController?.popViewController(animated: true)
    }

    func listDetailViewController(
      _ controller: ListDetailViewController,
      didFinishEditing checklist: Checklist
    ) {
        if let index = dataModel.lists.firstIndex(of: checklist) {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) {
          cell.textLabel!.text = checklist.name
        }
      }
      navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      // 1
      dataModel.lists.remove(at: indexPath.row)

      // 2
      let indexPaths = [indexPath]
      tableView.deleteRows(at: indexPaths, with: .automatic)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
      // Update cell information
        let checklist = dataModel.lists[indexPath.row]
      cell.textLabel!.text = checklist.name
      cell.accessoryType = .detailDisclosureButton

      return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checklist = dataModel.lists[indexPath.row]
          performSegue(
            withIdentifier: "ShowChecklist",
            sender: checklist)
    }

    // MARK: - Navigation
    override func prepare(
      for segue: UIStoryboardSegue,
      sender: Any?
    ) {
      if segue.identifier == "ShowChecklist" {
        let controller = segue.destination as! ChecklistViewController
        controller.checklist = sender as? Checklist
      }
        else if segue.identifier == "AddChecklist" {
          let controller = segue.destination as! ListDetailViewController
          controller.delegate = self
        }
    }

}
