//
//  UnregularViewController.swift
//  Tracker
//
//  Created by Олег Кор on 03.11.2024.
//



import UIKit


final class UnregularViewController: UIViewController {
    let trackerColors = Colors()
    let trackerEmoji = Emoji()
    let categoryVC = TrackerViewController()
    
    private var selectedEmoji: String?
    private var selectedEmojiIndex: IndexPath?
    private var selectedColor: UIColor?
    private var selectedColorIndex: IndexPath?
    private var selectedCategory: String?
    
    /// Скролл экран для задания всех настроек привычки
    private lazy var unregularScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    /// Вьюшка внутри скролла
    private lazy var unregularContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Заголовок окна создания привычки
    private lazy var viewControllerName: UILabel = {
        let label = UILabel()
        label.text = "Новое нерегулярное событие"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Заголовок выбора названия привычки
    private lazy var unregularName: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.borderStyle = .none
        textField.backgroundColor = .ypAppBackground
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.clearButtonMode = .whileEditing
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(newTrackerName(_:)), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    /// Предупреждение об ограничении максимального количества символов
    private lazy var maxTrackerLength: UILabel = {
        let limit = UILabel()
        limit.text = "Ограничение 38 символов"
        limit.font = .systemFont(ofSize: 17, weight: .regular)
        limit.textColor = .red
        limit.translatesAutoresizingMaskIntoConstraints = false
        limit.isHidden = true
        return limit
    }()
    
    /// Таблица для перехода в подраздел Категории/Расписание
    private lazy var unregularPropertiesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.backgroundColor = .ypLightGray
        tableView.separatorStyle = .none
        tableView.separatorColor = .ypBlack
        tableView.separatorInset.left = 16
        tableView.separatorInset.right = 16
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "unregularCell")
        return tableView
    }()
    
    /// Отображение коллекции выбора эмоджи и цвета трекера
    private lazy var unregularCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 9
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    /// Кнопка отмены создания трекера
    private lazy var unregularTrackerDismiss: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .white
        button.tintColor = .red
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.accessibilityIdentifier = "unregularTrackerDismiss"
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(unregularTrackerDismissButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Кнопка создания трекера
    private lazy var unregularTrackerCreate: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.accessibilityIdentifier = "unregularTrackerCreate"
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(unregularTrackerCreateButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.accessibilityIdentifier = "UnregularVC"
        view.backgroundColor = .white
        
        createView()
      }

    private func createView() {
        let unregularButtonsStack = UIStackView(arrangedSubviews: [unregularTrackerDismiss, unregularTrackerCreate])
        unregularButtonsStack.axis = .horizontal
        unregularButtonsStack.alignment = .fill
        unregularButtonsStack.distribution = .fillEqually
        unregularButtonsStack.spacing = 8
        
        unregularPropertiesTableView.delegate = self
        unregularPropertiesTableView.dataSource = self
        
        unregularCollectionView.delegate = self
        unregularCollectionView.dataSource = self
        unregularCollectionView.register(UnregularCollectionViewCell.self, forCellWithReuseIdentifier: "unregularCell")
        unregularCollectionView.register(UnregularCellSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        view.addSubview(viewControllerName)
        view.addSubview(unregularScrollView)
        unregularScrollView.addSubview(unregularContentView)
        unregularScrollView.addSubview(unregularName)
        unregularScrollView.addSubview(maxTrackerLength)
        unregularScrollView.addSubview(unregularPropertiesTableView)
        unregularScrollView.addSubview(unregularCollectionView)
        unregularScrollView.addSubview(unregularButtonsStack)
        unregularButtonsStack.translatesAutoresizingMaskIntoConstraints = false
  
        
        NSLayoutConstraint.activate([
            viewControllerName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            viewControllerName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            unregularScrollView.topAnchor.constraint(equalTo: viewControllerName.bottomAnchor, constant: 24),
            unregularScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            unregularScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            unregularScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            unregularContentView.topAnchor.constraint(equalTo: unregularScrollView.topAnchor),
            unregularContentView.leadingAnchor.constraint(equalTo: unregularScrollView.leadingAnchor),
            unregularContentView.trailingAnchor.constraint(equalTo: unregularScrollView.trailingAnchor),
            unregularContentView.bottomAnchor.constraint(equalTo: unregularScrollView.bottomAnchor),
            unregularContentView.widthAnchor.constraint(equalTo: unregularScrollView.widthAnchor),
            
            unregularName.topAnchor.constraint(equalTo: unregularContentView.topAnchor, constant: 24),
            unregularName.centerXAnchor.constraint(equalTo: unregularContentView.centerXAnchor),
            unregularName.leadingAnchor.constraint(equalTo: unregularContentView.leadingAnchor, constant: 16),
            unregularName.trailingAnchor.constraint(equalTo: unregularContentView.trailingAnchor, constant: -16),
            unregularName.heightAnchor.constraint(equalToConstant: 75),
            
            maxTrackerLength.topAnchor.constraint(equalTo: unregularName.bottomAnchor),
            maxTrackerLength.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            maxTrackerLength.heightAnchor.constraint(equalToConstant: 22),
            
            unregularPropertiesTableView.topAnchor.constraint(equalTo: unregularName.bottomAnchor, constant: 24),
            unregularPropertiesTableView.centerXAnchor.constraint(equalTo: unregularContentView.centerXAnchor),
            unregularPropertiesTableView.leadingAnchor.constraint(equalTo: unregularContentView.leadingAnchor, constant: 16),
            unregularPropertiesTableView.trailingAnchor.constraint(equalTo: unregularContentView.trailingAnchor, constant: -16),
            unregularPropertiesTableView.heightAnchor.constraint(equalToConstant: 75),
            
            unregularCollectionView.topAnchor.constraint(equalTo: unregularPropertiesTableView.bottomAnchor, constant: 32),
            unregularCollectionView.leadingAnchor.constraint(equalTo: unregularContentView.leadingAnchor),
            unregularCollectionView.trailingAnchor.constraint(equalTo: unregularContentView.trailingAnchor),
            unregularCollectionView.bottomAnchor.constraint(equalTo: unregularPropertiesTableView.bottomAnchor, constant: 492),
            
            unregularButtonsStack.topAnchor.constraint(equalTo: unregularCollectionView.bottomAnchor, constant: 16),
            unregularButtonsStack.leadingAnchor.constraint(equalTo: unregularContentView.leadingAnchor, constant: 16),
            unregularButtonsStack.trailingAnchor.constraint(equalTo: unregularContentView.trailingAnchor, constant: -16),
            unregularButtonsStack.bottomAnchor.constraint(equalTo: unregularContentView.bottomAnchor),
            unregularButtonsStack.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc func unregularTrackerDismissButtonPressed() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func unregularTrackerCreateButtonPressed() {
        let alert = UIAlertController(title: "Внимание!",
                                      message: "Данная функция доступна \nв платной версии",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func newTrackerName(_ sender: UITextField) {
        blockButtons()
    }
    
    /// Функция блокировки кнопок создания трекера в случае если поля не заполнены
    private func blockButtons() {
        guard let trackerName = unregularName.text else { return }
        
        if trackerName.isEmpty == false && selectedCategory != "" &&
            selectedEmoji != "" && selectedColor != nil && trackerName.count < 38 {
            unregularTrackerCreate.isEnabled = true
            unregularTrackerCreate.backgroundColor = .black
        } else {
            unregularTrackerCreate.isEnabled = false
            unregularTrackerCreate.backgroundColor = .gray
        }
        if trackerName.count > 38 {
            maxTrackerLength.isHidden = false
        } else {
            maxTrackerLength.isHidden = true
        }
    }
}

extension UnregularViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "unregularCell")
        
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true
        
        let trackerCategory = selectedCategory ?? ""
        cell.textLabel?.text = "Категория"
        cell.detailTextLabel?.text = trackerCategory
        cell.detailTextLabel?.textColor = .gray
        
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            cell.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 75
        }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
            let controller = UnregularCategoryViewController()
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
    }
}

extension UnregularViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == textField {
            print("ВВЕДЕНО НАЗВАНИЕ ТРЕКЕРА: \(textField)")
        }
        blockButtons()
    }
}

extension UnregularViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return trackerEmoji.trackerEmoji.count
        } else {
            return trackerColors.trackerBackgroundColors.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let unregularCell = unregularCollectionView.dequeueReusableCell(withReuseIdentifier: "unregularCell", for: indexPath) as? UnregularCollectionViewCell else {return UICollectionViewCell() }
        
        unregularCell.collectionLable.text = ""
        unregularCell.collectionLable.backgroundColor = .clear
        
        if indexPath.section == 0 {
            let emoji = trackerEmoji.trackerEmoji[indexPath.item]
            unregularCell.collectionLable.text = emoji
            
            
            if selectedEmojiIndex == indexPath {
                unregularCell.contentView.backgroundColor = .lightGray
                unregularCell.contentView.layer.cornerRadius = 16
            } else {
                unregularCell.contentView.backgroundColor = .clear
                unregularCell.layer.borderColor = UIColor.clear.cgColor
                unregularCell.layer.borderWidth = 0
            }
        } else {
            let color = trackerColors.trackerBackgroundColors[indexPath.item]
            unregularCell.collectionLable.backgroundColor = color
        
            if selectedColorIndex == indexPath {
                unregularCell.layer.cornerRadius = 8
                unregularCell.layer.borderColor = color.withAlphaComponent(0.3).cgColor
                unregularCell.layer.borderWidth = 3
            } else {
                unregularCell.contentView.backgroundColor = .clear
                unregularCell.layer.borderColor = UIColor.clear.cgColor
                unregularCell.layer.borderWidth = 0
            }
        }
        return unregularCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String                                      // 1
        switch kind {                                       // 2
        case UICollectionView.elementKindSectionHeader:     // 3
            id = "header"
        case UICollectionView.elementKindSectionFooter:     // 4
            id = "footer"
        default:
            id = ""                                         // 5
        }
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! UnregularCellSupplementaryView // 6
        if indexPath.section == 0 {
            view.titleLabel.text = "Emoji"
            return view
        } else {
            view.titleLabel.text = "Цвет"
            return view
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedEmojiIndex = indexPath
            selectedEmoji = trackerEmoji.trackerEmoji[indexPath.item]
            unregularCollectionView.reloadData()
            blockButtons()
        } else {
            selectedColorIndex = indexPath
            selectedColor = trackerColors.trackerBackgroundColors[indexPath.item]
            unregularCollectionView.reloadData()
            blockButtons()
        }
    }
}

/// Параметры расположения ячеек
extension UnregularViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { // 1
        return CGSize(width: 52, height: 52)   // 2
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 19)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 18)           // 5
    }
    
}

extension UnregularViewController: UnregularCategoryViewControllerDelegate {
    func newUnregularCategory(category: String) {
        self.selectedCategory = category
        blockButtons()
        unregularPropertiesTableView.reloadData()
    }
}
    

