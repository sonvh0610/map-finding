//
//  TypeAtmViewController.swift
//  MapFinding
//
//  Created by MAC MINI on 6/27/18.
//  Copyright © 2018 University of Science. All rights reserved.
//

import UIKit

protocol TypeAtmViewControllerDelegate: class {
    func chooseTypeForAtm (type :String)
}

class TypeAtmViewController: UIViewController {
    class func loadController () -> TypeAtmViewController{
        return TypeAtmViewController.init(nibName: "TypeAtmViewController", bundle: nil)
    }
    
    let typeAtm = ["All","Argibank","SacomBank","TechcomBank","ViettinBank"]
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var listTypeTableView: UITableView!
    weak var delegate: TypeAtmViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        listTypeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        self.listTypeTableView.delegate = self
        self.listTypeTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupUI () {
        self.titleLabel.text = NSLocalizedString("Choose a bank", comment: "")
        
    }

    
    @IBAction func touchUpInsideBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension TypeAtmViewController:UITableViewDelegate {}

extension TypeAtmViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeAtm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel?.text = NSLocalizedString(typeAtm[indexPath.row], comment: "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(typeAtm[indexPath.row])
        self.dismiss(animated: true, completion: nil)
        self.delegate?.chooseTypeForAtm(type: typeAtm[indexPath.row])
    }
}
