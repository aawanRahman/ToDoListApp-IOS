//
//  ViewController.swift
//  ToDoListApp
//
//  Created by aawan on 24/3/21.
//  Copyright © 2021 aawan. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListItem: Object {
    @objc dynamic var item: String = ""
    @objc dynamic var date: Date = Date()
    

}
class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].item
        return cell
    }
    
     private let realm = try! Realm()
    private var data = [ToDoListItem]()
    @IBOutlet var table:UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        data = realm.objects(ToDoListItem.self).map({$0})
        // Do any additional setup after loading the view.
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //table.register(UITableView, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = data[indexPath.row]
        guard let vc = storyboard?.instantiateViewController(identifier: "view") as? ViewViewController else {
            return
        }
        vc.item = item
        vc.deletionHandler = {[weak self] in
            self?.refresh()
            
            
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = item.item
       navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTapAddButton() {
        guard let vc = storyboard?.instantiateViewController(identifier: "enter") as? EntryViewController else {
            return
        }
        vc.completionHandler = { [weak self] in
            self?.refresh()
            
        }
        vc.title = "New Item"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    func refresh() {
        
        data = realm.objects(ToDoListItem.self).map({$0})
        table.reloadData()
        
        
    }

    

}

