//
//  SettingsViewController.swift
//  Tabman-Example
//
//  Created by Merrick Sapsford on 27/02/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    weak var tabViewController: TabViewController?
    fileprivate var sections = [SettingsSection]()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Settings"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
        
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeButtonPressed(_:)))
        self.navigationItem.leftBarButtonItem = closeButton
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50.0
        
        self.addItems()
    }

    func addItems() {
        
        let pageVCSection = SettingsSection(title: "Page View Controller")
        pageVCSection.add(item: SettingsItem(type: .toggle,
                                             title: "Infinite Scrolling",
                                             description: "Whether the page view controller should infinitely scroll between page ranges.",
                                             value: self.tabViewController?.isInfiniteScrollEnabled,
                                             update:
            { (value) in
                self.tabViewController?.isInfiniteScrollEnabled = value as! Bool
        }))
        sections.append(pageVCSection)
        
        self.tableView.reloadData()
    }
    
    // MARK: Actions
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].tableView(tableView, numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.sections[indexPath.section].item(atIndex: indexPath.row)
        guard let reuseIdentifier = item?.type.reuseIdentifier else {
            return UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if let toggleCell = cell as? SettingsToggleCell {
            toggleCell.titleLabel.text = item?.title
            toggleCell.descriptionLabel.text = item?.description
            toggleCell.toggle.isOn =  (item?.value as? Bool) ?? false
            toggleCell.delegate = item
        }
        
        return cell
    }
}
