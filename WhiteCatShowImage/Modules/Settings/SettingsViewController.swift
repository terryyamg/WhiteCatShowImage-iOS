//
//  SettingsViewController.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/8/13.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit

class SettingsViewController: ViewControllerWithSideMenu {

    @IBOutlet weak var tableView: UITableView!
    
    weak var coordinator: SettingsCoordinator?
    var viewModel: ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
