//
//  HabitViewController.swift
//  Tracker
//
//  Created by Олег Кор on 04.11.2024.
//

import UIKit

final class HabitViewController: UIViewController {
    let trackerColors = Colors()
    
    // Заголовок
    private let viewControllerName: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let habbitName: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .gray
        textField.layer.cornerRadius = 16
        return textField
    }()
    
    private let habbitProperties: UIView = {
        let myView = UIView()
        myView.backgroundColor = .appBackground
        myView.layer.cornerRadius = 16
        return myView
    }()
    
    private let habbitCategory: UILabel = {
        let category = UILabel()
        category.text = "Категория"
        category.font = .systemFont(ofSize: 17, weight: .regular)
        return category
    }()
    
    // Кнопка перехода в меню выбора категории
    private let habbitCategoryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.accessibilityIdentifier = "habbitCategoryButton"
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(habitCategoryButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let categoryButtonImage: UIImageView = {
       let image = UIImageView()
        image.image = .direction
        return image
    }()
    
    private let lineView: UIView = {
        let myView = UIView()
        myView.backgroundColor = .white
        return myView
    }()
    
    private let habbitSchedule: UILabel = {
        let schedule = UILabel()
        schedule.text = "Расписание"
        schedule.font = .systemFont(ofSize: 17, weight: .regular)
        return schedule
    }()
    
    // Кнопка выбора категории
    private let habbitScheduleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.accessibilityIdentifier = "habitScheduleButton"
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(habitScheduleButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let scheduleButtonImage: UIImageView = {
       let image = UIImageView()
        image.image = .direction
        return image
    }()
    
//    let emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let colorsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.accessibilityIdentifier = "HabitVC"
        view.backgroundColor = .white
        
        
        view.addSubview(viewControllerName)
        viewControllerName.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(habbitName)
        habbitName.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
        view.addSubview(habbitProperties)
        habbitProperties.translatesAutoresizingMaskIntoConstraints = false
        
        habbitProperties.addSubview(habbitCategory)
        habbitCategory.translatesAutoresizingMaskIntoConstraints = false
        
        habbitProperties.addSubview(habbitCategoryButton)
        habbitCategoryButton.translatesAutoresizingMaskIntoConstraints = false
       
        habbitProperties.addSubview(categoryButtonImage)
        categoryButtonImage.translatesAutoresizingMaskIntoConstraints = false
        
        habbitProperties.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        habbitProperties.addSubview(habbitSchedule)
        habbitSchedule.translatesAutoresizingMaskIntoConstraints = false
        
        habbitProperties.addSubview(habbitScheduleButton)
        habbitScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        
        habbitProperties.addSubview(scheduleButtonImage)
        scheduleButtonImage.translatesAutoresizingMaskIntoConstraints = false
        
        
        
//        view.addSubview(emojiCollectionView)
//        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(colorsCollectionView)
        colorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint()
        
//        emojiCollectionView.dataSource = self
//        emojiCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "emojiCell")
        
        colorsCollectionView.dataSource = self
        colorsCollectionView.register(ColorsCollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
    }
    
    func addConstraint() {
        NSLayoutConstraint.activate([
            viewControllerName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            viewControllerName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            habbitName.topAnchor.constraint(equalTo: viewControllerName.bottomAnchor, constant: 24),
            habbitName.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            habbitName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            habbitName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            habbitName.heightAnchor.constraint(equalToConstant: 75),
            
            habbitProperties.topAnchor.constraint(equalTo: habbitName.bottomAnchor, constant: 24),
            habbitProperties.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            habbitProperties.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            habbitProperties.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            habbitProperties.heightAnchor.constraint(equalToConstant: 150),
            
            habbitCategory.topAnchor.constraint(equalTo: habbitProperties.topAnchor, constant: 27),
            habbitCategory.heightAnchor.constraint(equalToConstant: 24),
            habbitCategory.leadingAnchor.constraint(equalTo: habbitProperties.leadingAnchor, constant: 16),
            
            habbitCategoryButton.topAnchor.constraint(equalTo: habbitName.bottomAnchor, constant: 24),
            habbitCategoryButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            habbitCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            habbitCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            habbitCategoryButton.heightAnchor.constraint(equalToConstant: 75),

            categoryButtonImage.topAnchor.constraint(equalTo: habbitProperties.topAnchor, constant: 27),
            categoryButtonImage.trailingAnchor.constraint(equalTo: habbitProperties.trailingAnchor, constant: -16),
           
            lineView.topAnchor.constraint(equalTo: habbitProperties.topAnchor, constant: 75),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.widthAnchor.constraint(equalToConstant: 311),
            lineView.leadingAnchor.constraint(equalTo: habbitProperties.leadingAnchor, constant: 16),
            
            habbitSchedule.bottomAnchor.constraint(equalTo: habbitProperties.bottomAnchor, constant: -27),
            habbitSchedule.heightAnchor.constraint(equalToConstant: 24),
            habbitSchedule.leadingAnchor.constraint(equalTo: habbitProperties.leadingAnchor, constant: 16),
            
            habbitScheduleButton.topAnchor.constraint(equalTo: habbitProperties.topAnchor, constant: 75),
            habbitScheduleButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            habbitScheduleButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            habbitScheduleButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            habbitScheduleButton.heightAnchor.constraint(equalToConstant: 75),
            
            scheduleButtonImage.bottomAnchor.constraint(equalTo: habbitProperties.bottomAnchor, constant: -27),
            scheduleButtonImage.trailingAnchor.constraint(equalTo: habbitProperties.trailingAnchor, constant: -16),
            
            
//            emojiCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 437),
//            emojiCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 348),
//            emojiCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
//            emojiCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 24),
            
            colorsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 675),
            colorsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 110),
            colorsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            colorsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 24)
        ])
    }
    
    
    @objc func habitCategoryButtonPressed() {
        let controller = HabitCategoryViewController()
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func habitScheduleButtonPressed() {
        let controller = HabitScheduleViewController()
        self.present(controller, animated: true, completion: nil)
    }
    
}

extension HabitViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField,
                                   reason: UITextField.DidEndEditingReason){
           if let value = textField.text  {
                print(value)
           }
       }
}

extension HabitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackerColors.trackerBackgroundColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let colorCell = colorsCollectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
        colorCell.backgroundColor = trackerColors.trackerBackgroundColors[indexPath.row]
        colorCell.layer.cornerRadius = 8
        return colorCell
    }
}
