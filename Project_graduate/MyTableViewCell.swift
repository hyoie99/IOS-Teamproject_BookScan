//
//  MyTableViewCell.swift
//  Project_graduate
//
//  Created by 윤한솔 on 2023/04/10.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    @IBOutlet weak var sendTitleButton: UIButton!
    
    var indicatorActive: (()->Void)?
    weak var delegate : customTableViewCellDelegate?
    
    @IBAction func onBtnSendTitle(_ sender: UIButton) {
        print("1000")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.sendTitleButton.backgroundColor = UIColor(red: 0.0/255.0, green: 171.0/255.0, blue: 179.0/255.0, alpha: 1.0)
        }
//        self.sendTitleButton.backgroundColor = UIColor(red: 0.0/255.0, green: 171.0/255.0, blue: 179.0/255.0, alpha: 1.0)
        // 누른 버튼 색 바뀌기
        indicatorActive?()
        TitleManager.shared.Title = sendTitleButton.titleLabel?.text
        print("sendbutton : \(TitleManager.shared.Title!)")
        ImageDataManager.shared.saveTitle(TitleManager.shared.Title)
        delegate?.didTapButtonCell()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6))
        
        sendTitleButton.frame = self.sendTitleButton.frame
        
    }
}
protocol customTableViewCellDelegate : AnyObject {
    func didTapButtonCell()
}
