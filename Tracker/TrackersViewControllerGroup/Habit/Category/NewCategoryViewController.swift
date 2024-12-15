//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Олег Кор on 09.12.2024.
//

import UIKit

protocol NewCategoryViewControllerDelegate: AnyObject {
    func createNewCategoryName(categoryName: String)
}

final class NewCategoryViewController: UIViewController, UITextFieldDelegate {
    
    weak var delegate: NewCategoryViewControllerDelegate?
    
    /// Заголовок окна создания новой категории
    private lazy var  newCategoryTitle: UILabel = {
        let label = UILabel()
        label.text = "Новая категория"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Заголовок ввода названия новой категории
    private lazy var newCategoryName: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название категории"
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.borderStyle = .none
        textField.backgroundColor = .ypAppBackground
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.clearButtonMode = .whileEditing
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(editCategoryName(_:)), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // Кнопка создания новой категории
    private lazy var newCategoryCreate: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .ypGray
        button.accessibilityIdentifier = "newCategoryCreate"
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(newCategoryCreateButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "NewCategoryVC"
        view.backgroundColor = .ypWhite
        
        newCategoryName.delegate = self
        
        createView()
    }
    
    /// Метод создания UI
    private func createView() {
        
        view.addSubview(newCategoryTitle)
        view.addSubview(newCategoryName)
        view.addSubview(newCategoryCreate)
        
        NSLayoutConstraint.activate([
            newCategoryTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            newCategoryTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            newCategoryName.topAnchor.constraint(equalTo: newCategoryTitle.bottomAnchor, constant: 38),
            newCategoryName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newCategoryName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            newCategoryName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newCategoryName.heightAnchor.constraint(equalToConstant: 75),
            
            newCategoryCreate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newCategoryCreate.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            newCategoryCreate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            newCategoryCreate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            newCategoryCreate.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    
    @objc private func editCategoryName(_ sender: UITextField) {
        blockButtons()
    }
    
    /// Функция блокировки кнопок создания трекера в случае если поля не заполнены
    private func blockButtons() {
        guard let categoryName = newCategoryName.text else { return }
        
        if categoryName.isEmpty == false {
            newCategoryCreate.isEnabled = true
            newCategoryCreate.backgroundColor = .ypBlack
        } else {
            newCategoryCreate.isEnabled = false
            newCategoryCreate.backgroundColor = .ypGray
        }
    }
    
    @objc private func newCategoryCreateButtonPressed() {
        guard let categoryName = newCategoryName.text else { return }
        delegate?.createNewCategoryName(categoryName: categoryName)
        dismiss(animated: true, completion: nil)
    }
}
