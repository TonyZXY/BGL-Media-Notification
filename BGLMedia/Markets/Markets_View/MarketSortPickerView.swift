//
//  MarketSortPickerView.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 1/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import RealmSwift

class MarketSortPickerView:UITextField,UIPickerViewDelegate, UIPickerViewDataSource{
    var sortItems:[String]{
        get{
            return [textValue(name: "sortByLetter_market"),textValue(name: "sortByHighestPrice_market")]
        }
    }
    let pickerview = UIPickerView()
    
    
    
    weak var sortPickerViewDelegate: SortPickerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setPickerViewToolbar()
        setPickerViewDoneButton()
    }
    
    func setupView(){
        tintColor = .clear
        layer.borderColor = UIColor.white.cgColor
        textColor = UIColor.white
        
//        sortItems.append(textValue(name: "sortByLetter_market"))
//        sortItems.append(textValue(name: "sortByHighestPrice_market"))
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            sortPickerViewDelegate?.reloadDataSortedByName()
            sortPickerViewDelegate?.setSortOption!(option: 0)
        } else {
            sortPickerViewDelegate?.reloadDataSortedByPrice()
            sortPickerViewDelegate?.setSortOption!(option: 1)
        }
    }
    
    func setPickerViewToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(setPickerViewDoneButton))
        toolbar.setItems([donebutton], animated: false)
        self.inputAccessoryView = toolbar
        self.inputView = pickerview
        pickerview.delegate = self
        pickerview.dataSource = self
        pickerview.selectRow(0, inComponent: 0, animated: true)
    }

    @objc func setPickerViewDoneButton(){
        let row = pickerview.selectedRow(inComponent: 0)
        self.text = "▼ "+sortItems[row]
        self.endEditing(true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objc protocol SortPickerViewDelegate: class {
    func reloadDataSortedByName()
    func reloadDataSortedByPrice()
    @objc optional func setSortOption(option: Int)
}
