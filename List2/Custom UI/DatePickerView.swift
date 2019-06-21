//
//  DatePickerView.swift
//  List2
//
//  Created by edan yachdav on 6/18/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class DatePickerView: UIView {
    
    private var viewTitleLabel: UILabel!
    private var datePicker: UIDatePicker!
    
    private var datePickerIsInView = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewSetup()
    }
    
    private func viewSetup() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        viewTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        viewTitleLabel.text = "Due date"
        viewTitleLabel.font = UIFont.systemFont(ofSize: 25, weight: .light)
        viewTitleLabel.textColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.8039215686, alpha: 1)
        viewTitleLabel.addGestureRecognizer(tapGestureRecognizer)
        viewTitleLabel.isUserInteractionEnabled = true
        
        self.addSubview(viewTitleLabel)
        
        let doubleTapGestureRecgonizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        doubleTapGestureRecgonizer.numberOfTapsRequired = 2
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        datePicker.datePickerMode = .date
        datePicker.addGestureRecognizer(doubleTapGestureRecgonizer)
        datePicker.isUserInteractionEnabled = true
        
    }
    
    @objc private func tapAction() {
        if !datePickerIsInView {
            viewTitleLabel.removeFromSuperview()
            self.addSubview(datePicker)
            datePickerIsInView = true
        } else {
            datePicker.removeFromSuperview()
            self.addSubview(viewTitleLabel)
            datePickerIsInView = false
        }
    }
}
