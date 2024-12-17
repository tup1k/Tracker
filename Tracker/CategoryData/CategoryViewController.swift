//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Олег Кор on 09.11.2024.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func newCategorySelect(category: String)
}

final class CategoryViewController: UIViewController {
    weak var delegate: CategoryViewControllerDelegate?
//    private var selectedCategory: String?
//    private var actualCategories: [String] = []
//    private var actualCategories: [TrackerCategoryCoreData] = []
    private let categoryVC = TrackerViewController()
    private let viewModel = CategoryViewModel()
    private let trackerCategoryStore = TrackerCategoryStore.shared
    
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
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorInset.left = 16
        tableView.separatorInset.right = 16
        tableView.separatorColor = .ypBlack
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
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
        button.addTarget(self, action: #selector(categoryButtonPressed), for: .touchUpInside)
        return button
    }()
    
        override func viewDidLoad() {
            super.viewDidLoad()
            view.accessibilityIdentifier = "HabitCategoryVC"
            view.backgroundColor = .ypWhite
            
            categoriesTableView.dataSource = self
            categoriesTableView.delegate = self
           
            binding()
            viewModel.loadCategoriesFromCoreData()
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
            categoriesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoriesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            createCategoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            createCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createCategoryButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
        
    /// Кнопка открывает окно создание новых категорий
    @objc private func categoryButtonPressed() {
        let controller = NewCategoryViewController()
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    func binding() {
        viewModel.didUpdateCategories = { [weak self] in
            guard let self else {return}
            categoryPlaceholderImage.isHidden = !viewModel.actualCategories.isEmpty
            categoryPlaceholderLabel.isHidden = !viewModel.actualCategories.isEmpty
            categoriesTableView.reloadData()
        }
        
        viewModel.didSelectedRaw = { [weak self] selectedCategory in
            guard let self else { return }
            categoriesTableView.visibleCells.enumerated().forEach{ index, cell in
                if self.viewModel.isSelectedCategory(category: self.viewModel.actualCategories[index]) {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
            DispatchQueue.main.async {
                self.delegate?.newCategorySelect(category: selectedCategory)
                print("ПОЛЬЗОВАТЕЛЬ ВЫБРАЛ КАТЕГОРИЮ: \(selectedCategory)")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.actualCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = viewModel.actualCategories[indexPath.row]
        cell.textLabel?.text = category
        cell.textLabel?.textColor = .ypBlack
        cell.backgroundColor = .ypAppBackground
        cell.selectionStyle = .none
//        cell.layer.cornerRadius = 16
//        cell.layer.masksToBounds = true
       
        cell.accessoryType = (viewModel.isSelectedCategory(category: category)) ? .checkmark : .none
       
        
        if indexPath.row == viewModel.actualCategories.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.layoutMargins = .zero
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            cell.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCategory(category: viewModel.actualCategories[indexPath.row])
    }
 
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        guard indexPath.row != 0 else {return nil}
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { action in
            let editAction =
                UIAction(title: NSLocalizedString("Редактировать", comment: ""),
                         image: UIImage(systemName: "pencil")) { action in
                    self.editCategoryName(indexPath: indexPath)
                }
           
            let deleteAction =
                UIAction(title: NSLocalizedString("Удалить", comment: ""),
                         image: UIImage(systemName: "trash"),
                         attributes: .destructive) { action in
                    self.deleteCategory(indexPath: indexPath)
                }
            return UIMenu(title: "", children: [editAction, deleteAction])
        })
    }
    
    
    private func editCategoryName(indexPath: IndexPath) {
        let controller = EditCategoryViewController()
        let category = viewModel.actualCategories[indexPath.row]
        controller.delegate = self
        controller.oldCategoryName = category
        self.present(controller, animated: true, completion: nil)
    }
    
    /// Метод удаления категории через алерт и viewmodel
    private func deleteCategory(indexPath: IndexPath) {
        let category = self.viewModel.actualCategories[indexPath.row]
        
        let alert = UIAlertController(title: "Эта категория точне не нужна?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Удалить",
                                      style: .destructive,
                                      handler: { [weak self] _ in
            
            guard let self else { return }
            self.viewModel.deleteCategory(category)
            
        }))
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension CategoryViewController: NewCategoryViewControllerDelegate {
    func createNewCategoryName(categoryName: String) {
        viewModel.addCategory(categoryName: categoryName)
        categoriesTableView.reloadData()
    }
}

extension CategoryViewController: EditCategoryViewControllerDelegate {
    func editNewCategoryName(oldCategoryName: String, newCategoryName: String) {
        try? viewModel.editCategory(categoryName: oldCategoryName, newCategoryName: newCategoryName)
        categoriesTableView.reloadData()
    }
}

