//
//  ViewController.swift
//  familyPage
//
//  Created by Георгий on 29.10.2021.
//

import UIKit
import PinLayout
import SkyFloatingLabelTextField

class ViewController: UIViewController {

    private let personalDataLabel: UILabel = UILabel()
    private var parentNameTextField = SkyFloatingLabelTextField(frame: CGRect(x: 0,
                                                                              y: 0,
                                                                              width: 60,
                                                                              height: 50))
    private var parentAgeTextField = SkyFloatingLabelTextField(frame: CGRect(x: 0,
                                                                              y: 0,
                                                                              width: 60,
                                                                              height: 50))
    private let childrenLabel: UILabel = UILabel()
    private let addButton: UIButton = UIButton()
    private let deleteButton: UIButton = UIButton()
    
    let userDefaults = UserDefaults.standard
    
    private var childrenData: [ChildTableViewCell] = []
    
    private let tableView: UITableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        parentNameTextField.delegate = self
        parentNameTextField.text = userDefaults.string(forKey: "ParentName")
        
        parentAgeTextField.delegate = self
        parentAgeTextField.text = userDefaults.string(forKey: "ParentAge")
                
        tableView.register(ChildTableViewCell.self, forCellReuseIdentifier: ChildTableViewCell.identifier)
        setupUI()
    }
    
  
    override func viewDidLayoutSubviews() {
        
        personalDataLabel.pin
            .top(view.pin.safeArea.top + 30)
            .right(view.pin.safeArea.right - 20)
            .width(view.frame.width)
            .height(25)
        
        parentNameTextField.pin
            .below(of: personalDataLabel)
            .marginTop(30)
            .horizontally(20)
            
        parentAgeTextField.pin
            .below(of: parentNameTextField)
            .marginTop(30)
            .horizontally(20)
        
        childrenLabel.pin
            .below(of: parentAgeTextField)
            .marginTop(50)
            .right(view.pin.safeArea.right - 20)
            .width(view.frame.width)
            .height(25)
        
        addButton.pin
            .below(of: parentAgeTextField)
            .marginTop(40)
            .right(view.pin.safeArea.right + 20)
            
        tableView.pin
            .below(of: addButton)
            .bottom(view.pin.safeArea.bottom + 60)
            .horizontally(12)
        
        deleteButton.pin
            .below(of: tableView)
            .marginTop(20)
            .hCenter()
    }
    
    private func setupUI() {
        
        personalDataLabel.text = "Персональные данные"
        personalDataLabel.font = .systemFont(ofSize: 25, weight: .semibold)
        
        parentNameTextField.placeholder = "Имя"
        parentNameTextField.title = "Ваше имя"
        
        parentAgeTextField.placeholder = "Возраст"
        parentAgeTextField.title = "Ваш возраст"
        
        childrenLabel.text = "Дети (макс.5)"
        childrenLabel.font = .systemFont(ofSize: 25, weight: .semibold)
        
        addButton.setTitle("Добавить", for: .normal)
        addButton.setTitleColor(.blue, for: .normal)
        addButton.setTitleColor(.gray, for: .highlighted)
        addButton.frame = CGRect(x: 0, y: 0, width: 180, height: 50)
        addButton.layer.cornerRadius = 25
        addButton.layer.borderWidth = 2
        addButton.layer.borderColor = UIColor.blue.cgColor
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        isButtonVisible()

        deleteButton.setTitle("Очистить", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.setTitleColor(.gray, for: .highlighted)
        deleteButton.frame = CGRect(x: 0, y: 0, width: 180, height: 50)
        deleteButton.layer.cornerRadius = 25
        deleteButton.layer.borderWidth = 2
        deleteButton.layer.borderColor = UIColor.red.cgColor
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        
        [personalDataLabel, parentNameTextField, parentAgeTextField, childrenLabel, addButton, tableView, deleteButton].forEach {
            view.addSubview($0)
        }
        
    }
    
    private func isButtonVisible() {
        
        if childrenData.count == 5 {
            addButton.isHidden = true
        } else {
            addButton.isHidden = false
        }
    }
    
    @objc private func didTapAddButton() {
        if childrenData.count < 5 {
            childrenData.append(ChildTableViewCell())
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath.init(row: self.childrenData.count - 1, section: 0)], with: .automatic)
            self.tableView.endUpdates()
        }
        isButtonVisible()
    }
    
    @objc private func didTapDeleteButton() {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Отменить", style: .cancel) { action -> Void in }
        let deleteAction: UIAlertAction = UIAlertAction(title: "Удалить данные", style: .default) { action -> Void in
            self.parentNameTextField.text = ""
            self.parentAgeTextField.text = ""
            self.childrenData.removeAll()
            self.tableView.reloadData()
        }
        
        actionSheetController.addAction(cancelAction)
        actionSheetController.addAction(deleteAction)
        
        present(actionSheetController, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        childrenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChildTableViewCell.identifier, for: indexPath) as? ChildTableViewCell else {
            return .init()
        }
        cell.delegate = self
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}

extension ViewController: ItemDelegate {
    func deleteClicked(cell: UITableViewCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        tableView.beginUpdates()
        childrenData.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
        isButtonVisible()
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case parentNameTextField:
            if let text = textField.text {
                userDefaults.set(text, forKey: "ParentName")
            }
        case parentAgeTextField:
            if let text = textField.text {
                userDefaults.set(text, forKey: "ParentAge")
            }
        default:
            print("Error occured")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == parentAgeTextField {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789 ")
                   let characterSet = CharacterSet(charactersIn: string)
                   return allowedCharacters.isSuperset(of: characterSet)
        }
        if textField == parentNameTextField {
            let allowedCharacters = CharacterSet(charactersIn:"йцукенгшщзхъфывапролджэёячсмитьбюЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЁЯЧСМИТЬБЮ ")
                   let characterSet = CharacterSet(charactersIn: string)
                   return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}
