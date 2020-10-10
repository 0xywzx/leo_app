//
//  EditItemViewController.swift
//  LeoShareExtension
//
//  Created by yosuke.aramaki on 2020/10/10.
//

import Foundation
import UIKit

protocol EditItemViewControllerDelegate {
	func itemFinishedEditing(newValue: String)
}

class EditItemViewController: UIViewController {
	var delegate: EditItemViewControllerDelegate!
	var currentValue: String!

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Edit Item"
		textView.insertText(currentValue)
		view.addSubview(textView)
        
		textView.becomeFirstResponder()
		
		let doneButton = UIBarButtonItem(title: "Done", style: .done, target: nil, action: #selector(doneButtonClicked(_:)))
		navigationItem.rightBarButtonItem = doneButton
	}
    
    @objc func doneButtonClicked(){
			let newValue = textView.text!
			delegate.itemFinishedEditing(newValue: newValue)
    }

	lazy var textView: UITextView = {
		let frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.width, height: self.view.frame.height)
		let tView = UITextView(frame: frame)
		tView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		return tView
	}()
}
