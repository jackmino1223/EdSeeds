//
//  ESEndorsementListVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 2/8/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

class ESEndorsementListVC: ESViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblEndorsementList: UITableView!
    
    var endorsements: [ESEndorsmentModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView datasource, delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endorsements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ESEndorsementUserCellIdentifier) as! ESEndorsementUserCell
        cell.endorsementUser = endorsements[indexPath.row]
        
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
