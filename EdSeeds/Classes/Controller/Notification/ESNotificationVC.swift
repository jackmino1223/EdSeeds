//
//  ESNotificationVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/22/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class ESNotificationVC: ESTopBaseVC, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblNotifications: UITableView!
    
    fileprivate var notifications: [ESNotificationModel] = []
    fileprivate var isLoading: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tblNotifications.register(UINib(nibName: "ESLoadingCell", bundle: nil), forCellReuseIdentifier: ESLoadingCellIdentifier)
        tblNotifications.backgroundColor = ESConstant.Color.ViewBackground
        
        loadNotifications()
        addPullToRefresh()
        
    }
    
    deinit {
//        removePullToRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllerTitle() -> String? {
        return "Notifications"
    }
    
    internal func addPullToRefresh() {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.white
        tblNotifications.dg_addPullToRefreshWithActionHandler({
            
            self.loadNotifications()
            
        }, loadingView: loadingView)
        tblNotifications.dg_setPullToRefreshBackgroundColor(ESConstant.Color.ViewBackground)
        tblNotifications.dg_setPullToRefreshFillColor(ESConstant.Color.DarkGreen)
    }
    
    internal func removePullToRefresh() {
        tblNotifications.dg_removePullToRefresh()
    }


    internal func loadNotifications() {
        if isLoading == false {
            isLoading = true
            self.tblNotifications.reloadData()
            
            requestManager().getNotification(user: appManager().currentUser!, complete: { (result: [ESNotificationModel]?, lastId: Int?, errorMessage: String?) in
                if result != nil {
                    self.notifications = result!
                    
                }
                self.isLoading = false
                self.tblNotifications.reloadData()
                self.tblNotifications.dg_stopLoading()
                self.readedNotification(lastId: lastId)
            })
        }
    }
    
    internal func readedNotification(lastId: Int?) {
        if lastId != nil {
            requestManager().readedNotification(user: appManager().currentUser!, lastId: lastId!, complete: { (errorMessage: String?) in
                if errorMessage != nil {
                    print("Notification mark as Read : error : %@", errorMessage!)
                } else {
                    for notification in self.notifications {
                        notification.seen = true
                    }
                    self.tblNotifications.reloadData()
                    self.tabBarItem.badgeValue = nil
                }
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: - UITableview datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading || (isLoading == false && notifications.count == 0) {
            return 1
        } else {
            return notifications.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading || (isLoading == false && notifications.count == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: ESLoadingCellIdentifier) as! ESLoadingCell
            if isLoading {
                cell.indicatorLoading.startAnimating()
                cell.lblTitle.text = "Loading..."
            } else {
                cell.indicatorLoading.stopAnimating()
                cell.lblTitle.text = "No notifications"
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ESNotificationGeneralCellIdentifier) as! ESNotificationGeneralCell
            cell.notification = notifications[indexPath.row]
            
            /*
            let notification = notifications[indexPath.row]
            var cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell")
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "NotificationCell")
                cell?.textLabel?.font = UIFont(name: ESConstant.FontName.Bold, size: 14)
                cell?.textLabel?.textColor = ESConstant.Color.DarkFontColor
                cell?.detailTextLabel?.font = UIFont(name: ESConstant.FontName.Regular, size: 12)
                cell?.detailTextLabel?.textColor = ESConstant.Color.GrayFontColor
            }
            
            cell?.textLabel?.text = notification.detailedTitle
            cell?.detailTextLabel?.text = notification.msgDescription
            cell?.contentView.backgroundColor = notification.seen ? ESConstant.Color.DarkFontColor : UIColor.white */
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let notification = notifications[indexPath.row]
        let currentUser = appManager().currentUser!
        if notification.notType >= 3 && currentUser.type == .studuent {
            let studentHomeVC = self.tabBarController!.viewControllers!.first as! ESStudentHomeVC
            studentHomeVC.showFromNotification(notification)
        } else if (notification.notType == 1) && (currentUser.type == .donor || currentUser.type == .advocate) {
            let donorHomeVC = self.tabBarController!.viewControllers!.first as! ESDonorHomeVC
            donorHomeVC.showFromNotification(notification)
        }
        self.tabBarController?.selectedIndex = 0
    }
}
