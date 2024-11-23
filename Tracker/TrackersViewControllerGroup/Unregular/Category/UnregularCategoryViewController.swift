//
//  HabitCategoryViewController.swift
//  Tracker
//
//  Created by Олег Кор on 23.11.2024.
//

import UIKit

protocol UnregularCategoryViewControllerDelegate: AnyObject {
    func newUnregularCategory(category: String)
}


final class UnregularCategoryViewController: UIViewController {
    weak var delegate: UnregularCategoryViewControllerDelegate?
    private var selectedCategory: String?
    private var actualCategories: [String] = []
    private let categoryVC = TrackerViewController()
    
    /// Заголовок
    private lazy var categoryTitle: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Таблица с категориями
    private lazy var categoriesTableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .ypLightGray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UnregularCategoryCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
  
    /// Картинка для заглушки
    private lazy var categoryPlaceholderImage: UIImageView = {
        let image = UIImageView()
        let placeholder = UIImage.trackerPlaceholder
        image.image = placeholder
        return image
    }()
    
    /// Текст для заглушки
    private lazy var categoryPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно \nобъединить по смыслу"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    /// Кнопка создания категории
    private lazy var createCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .ypBlack
        button.accessibilityIdentifier = "createCategoruButton"
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(unregularCategoryButtonPressed), for: .touchUpInside)
        return button
    }()
    
        override func viewDidLoad() {
            super.viewDidLoad()
            view.accessibilityIdentifier = "UnregularCategoryVC"
            view.backgroundColor = .ypWhite
            
            categoryVC.mokTrackers()
            actualCategories = categoryVC.categoryName
            
            categoriesTableView.dataSource = self
            categoriesTableView.delegate = self
            createView()
        }
    
    // Создание UI
    private func createView() {
        view.addSubview(categoryTitle)
        view.addSubview(categoriesTableView)
        view.addSubview(categoryPlaceholderImage)
        categoryPlaceholderImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(categoryPlaceholderLabel)
        categoryPlaceholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(createCategoryButton)
        createCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            categoryTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            categoryPlaceholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryPlaceholderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            categoryPlaceholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryPlaceholderLabel.topAnchor.constraint(equalTo: categoryPlaceholderImage.bottomAnchor, constant: 8),
            categoryPlaceholderLabel.heightAnchor.constraint(equalToConstant: 36),
            categoryPlaceholderLabel.widthAnchor.constraint(equalToConstant: 343),
            
            categoriesTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoriesTableView.topAnchor.constraint(equalTo: categoryTitle.bottomAnchor, constant: 24),
            categoriesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            categoriesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            createCategoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            createCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createCategoryButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        if actualCategories.count > 0 {
            categoryPlaceholderImage.isHidden = true
            categoryPlaceholderLabel.isHidden = true
            categoriesTableView.isHidden = false
        } else {
            categoryPlaceholderImage.isHidden = false
            categoryPlaceholderLabel.isHidden = false
            categoriesTableView.isHidden = true
        }
    }
        
    /// В данный момент эта кнопка сохраняет выбор категории
    @objc func unregularCategoryButtonPressed() {
        if let category = selectedCategory {
            delegate?.newUnregularCategory(category: category)
            print("ПОЛЬЗОВАТЕЛЬ ВЫБРАЛ КАТЕГОРИЮ: \(selectedCategory)")
        }
        dismiss(animated: true, completion: nil)
    }
}

extension UnregularCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        actualCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UnregularCategoryCell", for: indexPath)
        let category = actualCategories[indexPath.row]
        cell.textLabel?.text = category
        cell.textLabel?.textColor = .ypBlack
        cell.backgroundColor = .ypAppBackground
        cell.selectionStyle = .none
        cell.accessoryType = (category == selectedCategory) ? .checkmark : .none
        
        if indexPath.row == actualCategories.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: CGFloat.greatestFiniteMagnitude)
        } else {
            cell.separatorInset = .zero
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = actualCategories[indexPath.row]
        if selectedCategory == category {
            selectedCategory = nil
        } else {
            selectedCategory = category
        }
        tableView.reloadData()
    }
}


