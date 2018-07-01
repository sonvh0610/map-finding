//
//  ListPlacesViewController.swift
//  MapFinding
//
//  Created by Hoai-Son Vo on 7/1/18.
//  Copyright © 2018 University of Science. All rights reserved.
//

import UIKit
import ReSwift

class ListPlacesViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, StoreSubscriber {
    @IBOutlet weak var listPlaces: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainStore.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainStore.unsubscribe(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainStore.state.place.listPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = mainStore.state.place.listPlaces[indexPath.row].Name
        cell.detailTextLabel?.text = mainStore.state.place.listPlaces[indexPath.row].Vicinity
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainStore.dispatch(SelectPlace(index: indexPath.row))
        self.navigationController?.popViewController(animated: true)
    }
    
    func newState(state: AppState) {
        // code
    }
}
