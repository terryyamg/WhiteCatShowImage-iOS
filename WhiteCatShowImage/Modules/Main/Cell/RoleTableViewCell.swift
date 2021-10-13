//
//  RoleTableViewCell.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/8/23.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit
import Kingfisher
import LTMorphingLabel

class RoleTableViewCell: UITableViewCell, TableViewCellProtocol {
    
    @IBOutlet weak var ivRole: UIImageView!
    @IBOutlet weak var labRole: LTMorphingLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labRole.morphingEffect = .sparkle
        labRole.morphingDuration = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupInfo(with role: RoleData) {
        ivRole.kf.setImage(with: URL(string: role.image))
        labRole.text = role.name
    }
    
}
