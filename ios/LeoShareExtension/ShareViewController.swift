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
		item.value = ""
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

         print("ee")
//        print(Bundle.main.bundleIdentifier as Any)
        UserDefaults.standard.set("arguments1", forKey: "key-sample")
        
        let prefs = UserDefaults.standard.persistentDomain(forName: "group.com.example.leoApp")
        print(0, prefs)
        let prefs1 = UserDefaults.standard.persistentDomain(forName: "com.example.leoApp")
        print(1, prefs1)
        
        let prefs2 = UserDefaults.init(suiteName: "group.com.example.leoApp")
        print(2, prefs2?.dictionaryRepresentation() as Any)
        
        let prefs3 = UserDefaults.init(suiteName: "com.example.leoApp")
        print(3, prefs3?.dictionaryRepresentation() as Any)
        
        let prefs4 = UserDefaults.standard.persistentDomain(forName: "com.example.leoApp.LeoShareExtension")
        print(4, prefs4)
        
//        let userDefaults = UserDefaults(suiteName: "group.com.example.leoApp")
//        userDefaults?.synchronize()
//
//        let test = userDefaults?.object(forKey: "flutter.session") as! String?
//        print(test as Any)
//
//        let test1 = userDefaults?.object(forKey: "session") as! String?
//        print(test1 as Any)
//
//        let test3 = userDefaults?.string(forKey: "flutter.session")
//        print(test3 as Any)
//
//        let test4 = userDefaults?.string(forKey: "session")
//        print(test4 as Any)
//
//        userDefaults?.set("message", forKey: "flutter")
//        let test2 = userDefaults?.object(forKey: "flutter") as! String?
//        print(test2 as Any)
        
//        for (key, value) in UserDefaults.standard.dictionaryRepresentation().sorted(by: { $0.0 < $1.0 }) {
//            print("- \(key) => \(value)")
//        }
//
//        if (UserDefaults.standard.object(forKey: "flutter.session") != nil) {
//            print("object flutter.session")
//        }
//
//        if (UserDefaults.standard.string(forKey: "flutter.session") != nil) {
//            print("string flutter.session")
//        }
//
//        if (UserDefaults.standard.object(forKey: "session") != nil) {
//            print("object session")
//        }
//
//        if (UserDefaults.standard.string(forKey: "session") != nil) {
//            print("string session")
//        }
        
        
//        let name = UserDefaults.standard.object(forKey: "flutter.session") as? String ?? ""
//        print("1", name);
//
//        let name1 = UserDefaults.standard.string(forKey: "flutter.session")
//        print("1", name1)
        
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
