//
//  MyTableViewCell.swift
//  Project_graduate
//
//  Created by 윤한솔 on 2023/04/10.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    @IBOutlet weak var sendTitleButton: UIButton!
    
    @IBAction func onBtnSendTitle(_ sender: UIButton) {
        print("1000")
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6))
        
        sendTitleButton.frame = self.sendTitleButton.frame
        
    }
}
