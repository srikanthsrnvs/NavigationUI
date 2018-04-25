//
//  InstructionsViewCell.swift
//  LocateMockup
//
//  Created by dEEEP on 20/04/18.
//  Copyright © 2018 vannteqfarm. All rights reserved.
//

import UIKit

class InstructionsViewCell: UITableViewCell {

  @IBOutlet weak var mInstructImgView: UIImageView!
  @IBOutlet weak var mDistanceLbl: UILabel!
  @IBOutlet weak var mInstructLbl: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
