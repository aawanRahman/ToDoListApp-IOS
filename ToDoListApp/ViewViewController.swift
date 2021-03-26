//
//  ViewViewController.swift
//  ToDoListApp
//
//  Created by aawan on 24/3/21.
//  Copyright © 2021 aawan. All rights reserved.
//
import RealmSwift
import UIKit

class ViewViewController: UIViewController {
    public var item: ToDoListItem?
    public var deletionHandler: (() -> Void)?
    @IBOutlet var itemLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    private let realm = try! Realm()
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        itemLabel.text = item?.item
        dateLabel.text = Self.dateFormatter.string(from: item!.date)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDelete))

        // Do any additional setup after loading the view.
    }
    
    @objc private func didTapDelete() {
        guard let myitem = self.item else {
            return
            
        }
        realm.beginWrite()
        realm.delete(myitem)
        try! realm.commitWrite()
        deletionHandler?()
        navigationController?.popToRootViewController(animated: true)
        
    }
    


}
