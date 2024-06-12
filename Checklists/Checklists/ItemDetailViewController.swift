

import UIKit

protocol ItemDetailViewControllerDelegate: AnyObject {
  func ItemDetailViewControllerDidCancel(
    _ controller: ItemDetailViewController)
  func ItemDetailViewController(
    _ controller: ItemDetailViewController,
    didFinishAdding item: ChecklistItem
  )
  func ItemDetailViewController(
    _ controller: ItemDetailViewController,
    didFinishEditing item: ChecklistItem
  )
}


class ItemDetailViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    var itemToEdit: ChecklistItem?


    override func viewDidLoad() {
    super.viewDidLoad()
      navigationItem.largeTitleDisplayMode = .never
        if let item = itemToEdit {
           title = "Edit Item"
           textField.text = item.text
            doneBarButton.isEnabled = true
         }
  }

    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      textField.becomeFirstResponder()
    }
       
    // MARK: - Text Field Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      let oldText = textField.text!
      let stringRange = Range(range, in: oldText)!
      let newText = oldText.replacingCharacters(
        in: stringRange,
        with: string)
      
      doneBarButton.isEnabled = !newText.isEmpty
   
      return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
      doneBarButton.isEnabled = false
      return true
    }

    @IBAction func cancel() {
      delegate?.ItemDetailViewControllerDidCancel(self)
    }

    @IBAction func done() {
      if let item = itemToEdit {
        item.text = textField.text!
        delegate?.ItemDetailViewController(
          self,
          didFinishEditing: item)
      } else {
        let item = ChecklistItem()
        item.text = textField.text!
        delegate?.ItemDetailViewController(self, didFinishAdding: item)
      }
    }


}
