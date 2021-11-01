//
//  ChildTableViewCell.swift
//  familyPage
//
//  Created by Георгий on 29.10.2021.
//

import UIKit
import PinLayout
import SkyFloatingLabelTextField

protocol ItemDelegate {
    func deleteClicked(cell: UITableViewCell)
}

final class ChildTableViewCell: UITableViewCell {
    
    static let identifier: String = "childTableViewCell"
    
    private var childNameTextField = SkyFloatingLabelTextField()
    private var childAgeTextField = SkyFloatingLabelTextField()
    private let deleteChildButton: UIButton = UIButton()
    
    var delegate: ItemDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        selectionStyle = .none
        
        childNameTextField.frame = CGRect(x: 0, y: 0, width: contentView.frame.width/2, height: 40)
        childNameTextField.placeholder = "Имя"
        childNameTextField.title = "Имя ребёнка"
        childNameTextField.delegate = self
        
        childAgeTextField.frame = CGRect(x: 0, y: 0, width: contentView.frame.width/2, height: 40)
        childAgeTextField.placeholder = "Возраст"
        childAgeTextField.title = "Возраст ребёнка"
        childAgeTextField.delegate = self
        
        deleteChildButton.setTitle("Удалить", for: .normal)
        deleteChildButton.setTitleColor(.blue, for: .normal)
        deleteChildButton.setTitleColor(.gray, for: .highlighted)
        deleteChildButton.frame = CGRect(x: 0, y: 0, width: 140, height: 50)
        deleteChildButton.addTarget(self, action: #selector(didTapDeleteChildButton), for: .touchUpInside)

        [childNameTextField, childAgeTextField, deleteChildButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.pin
            .horizontally(12)
            .vertically(18)
        
        childNameTextField.pin
            .top(10)
            .left(20)
        
        childAgeTextField.pin
            .below(of: childNameTextField)
            .marginTop(25)
            .left(20)
        
        deleteChildButton.pin
            .vCenter()
            .right(30)
    }
    
    @objc private func didTapDeleteChildButton() {
        delegate?.deleteClicked(cell: self)
    }
}

extension ChildTableViewCell: UITextFieldDelegate {
    
 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == childAgeTextField {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789 ")
                   let characterSet = CharacterSet(charactersIn: string)
                   return allowedCharacters.isSuperset(of: characterSet)
        }
        if textField == childNameTextField {
            let allowedCharacters = CharacterSet(charactersIn:"йцукенгшщзхъфывапролджэёячсмитьбюЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЁЯЧСМИТЬБЮ ")
                   let characterSet = CharacterSet(charactersIn: string)
                   return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
}
