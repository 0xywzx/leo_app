//
//  ShareViewController.swift
//  LeoShareExtension
//
//  Created by yosuke.aramaki on 2020/10/09.
//
import UIKit
import Social
import MobileCoreServices
import Photos

class ShareViewController: SLComposeServiceViewController, EditItemViewControllerDelegate {
    
	func itemFinishedEditing(newValue: String) {
		editConfigrationItem.value = newValue
		popConfigurationViewController()
	}
    
	let hostAppBundleIdentifier = "com.example.leoApp"
	let sharedKey = "ShareKeyd"
	var sharedText: [String] = []
	let urlContentType = kUTTypeURL as String

	override func isContentValid() -> Bool {
		// Do validation of contentText and/or NSExtensionContext attachments here
		return true
	}

	override func configurationItems() -> [Any]! {
		let configurationItems = [editConfigrationItem]
		return configurationItems
	}
	
	lazy var editConfigrationItem: SLComposeSheetConfigurationItem = {
		let item = SLComposeSheetConfigurationItem()!
		item.title = "メモ"
		item.value = "dddd"
		item.tapHandler = self.editConfigrationItemTapped
		return item
	} ()
    
	func editConfigrationItemTapped() {
			
		let controller = EditItemViewController()
		controller.currentValue = editConfigrationItem.value
		controller.delegate = self
		
		pushConfigurationViewController(controller)
	}
    

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Leo";

		let c: UIViewController = self.navigationController!.viewControllers[0]
		c.navigationItem.leftBarButtonItem!.title = "キャンセル"
		c.navigationItem.rightBarButtonItem!.title = "保存"

	}

	override func didSelectPost() {
		if let content = extensionContext!.inputItems[0] as? NSExtensionItem {
			if let contents = content.attachments {
				for (index, attachment) in (contents).enumerated() {
					if attachment.hasItemConformingToTypeIdentifier(urlContentType) {
						handleUrl(content: content, attachment: attachment, index: index)
					}
				}
			}
		}
	}

	private func handleUrl (content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
		attachment.loadItem(forTypeIdentifier: urlContentType, options: nil) { [weak self] data, error in
			if error == nil, let item = data as? URL, let this = self {
				this.sharedText.append(item.absoluteString)
				if index == (content.attachments?.count)! - 1 {
					let userDefaults = UserDefaults(suiteName: "group.\(this.hostAppBundleIdentifier)")
					userDefaults?.set(this.sharedText, forKey: this.sharedKey)
					userDefaults?.synchronize()
					this.redirectToHostApp(type: .text)
				}
			}
		}
	}

	private func redirectToHostApp(type: RedirectType) {
		let url = URL(string: "ShareMedia://dataUrl=\(sharedKey)#\(type)")
		var responder = self as UIResponder?
		let selectorOpenURL = sel_registerName("openURL:")
		while (responder != nil) {
			if (responder?.responds(to: selectorOpenURL))! {
				let _ = responder?.perform(selectorOpenURL, with: url)
			}
			responder = responder!.next
		}
	}
	enum RedirectType {
		case media
		case text
		case file
	}
}
