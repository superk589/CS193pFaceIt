//
//  ExpressionEditorViewController.swift
//  CS193pFaceIt
//
//  Created by zzk on 2017/4/7.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class ExpressionEditorViewController: UITableViewController, UITextFieldDelegate {
    
    var name: String {
        return nameTextField.text ?? ""
    }
    
    private let eyeChoices = [FacialExpression.Eyes.open, .closed, .squinting]
    
    private let mouthCoices = [FacialExpression.Mouth.frown, .smirk, .neutral, .grin, .smile]
    
    
    var expression: FacialExpression {
        return FacialExpression(eyes: eyeChoices[eyeControl?.selectedSegmentIndex ?? 0], mouth: mouthCoices[mouthControl?.selectedSegmentIndex ?? 0])
    }

    @IBOutlet weak var mouthControl: UISegmentedControl!
    @IBOutlet weak var eyeControl: UISegmentedControl!
    @IBAction func updateFace(_ sender: UISegmentedControl) {
        faceViewController?.expression = expression
    }
    @IBOutlet weak var nameTextField: UITextField!
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // this line does the same thing, because it will look forward in the presented stack until a vc that can do the dismiss
        // self.dismiss(animated: true, completion: nil)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return tableView.bounds.width
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private var faceViewController: BlinkingViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Embed Face" {
            faceViewController = segue.destination as? BlinkingViewController
            faceViewController?.expression = expression
        }
    }
    
    private func handleUnnamedFace() {
        let alert = UIAlertController(title: "Invalid Face", message: "A face must have a name.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.nameTextField.text = alert.textFields?.first?.text
            self.performSegue(withIdentifier: "Add Emotion", sender: nil)
        }))
        alert.addTextField(configurationHandler: nil)
        present(alert, animated: true, completion: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "Add Emotion", name.isEmpty {
            handleUnnamedFace()
            return false
        } else {
            return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let popoverPresentationController = navigationController?.popoverPresentationController {
            if popoverPresentationController.arrowDirection != .unknown {
                navigationItem.leftBarButtonItem = nil
            }
        }
        var size = tableView.minimumSize(forSection: 0)
        size.height -= tableView.heightForRow(at: IndexPath(row: 1, section: 0))
        size.height += size.width
        preferredContentSize = size
    }
    
}

extension UITableView
{
    func minimumSize(forSection section: Int) -> CGSize {
        var width: CGFloat = 0
        var height : CGFloat = 0
        for row in 0..<numberOfRows(inSection: section) {
            let indexPath = IndexPath(row: row, section: section)
            if let cell = cellForRow(at: indexPath) ?? dataSource?.tableView(self, cellForRowAt: indexPath) {
                
                // ask the system autolayout minimum size of the content view in a cell
                let cellSize = cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
                width = max(width, cellSize.width)
                height += heightForRow(at: indexPath)
            } }
        return CGSize(width: width, height: height)
    }
    func heightForRow(at indexPath: IndexPath? = nil) -> CGFloat {
        if indexPath != nil, let height = delegate?.tableView?(self, heightForRowAt: indexPath!) {
            return height
        } else {
            return rowHeight
        }
    }
}
