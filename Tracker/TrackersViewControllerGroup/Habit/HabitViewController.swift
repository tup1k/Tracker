//
//  HabitViewController.swift
//  Tracker
//
//  Created by Олег Кор on 04.11.2024.
//

import UIKit

protocol AddNewTrackerViewControllerDelegate: AnyObject {
    func addTracker(tracker: Tracker)
    func addEmoji(emoji: String)
    func addColor(color: UIColor)
}

final class HabitViewController: UIViewController {
    let trackerColors = Colors()
    let trackerEmoji = Emoji()
    let categoryVC = TrackerViewController()
    
    weak var delegate: AddNewTrackerViewControllerDelegate?
    
    private var selectedEmoji: String?
    private var selectedEmojiIndex: IndexPath?
    private var selectedColor: UIColor?
    private var selectedColorIndex: IndexPath?
    private var selectedCategory: String?
    private var selectedSchedule: String?
    private var schedule:[Days] = []
    
    /// Скролл экран для задания всех настроек привычки
    private lazy var habbitScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    /// Вьюшка внутри скролла
    private lazy var habbitContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Заголовок окна создания привычки
    private lazy var viewControllerName: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Заголовок выбора названия привычки
    private lazy var habbitName: UITextField = {
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
    private lazy var habbitPropertiesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.backgroundColor = .ypLightGray
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .ypBlack
        tableView.separatorInset.left = 16
        tableView.separatorInset.right = 16
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Properties cell")
        return tableView
    }()
    
    /// Отображение коллекции выбора эмоджи и цвета трекера
    private lazy var habbitCollectionView: UICollectionView = {
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
    private lazy var habbitTrackerDismiss: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .white
        button.tintColor = .red
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.accessibilityIdentifier = "habbitTrackerDismiss"
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(habitTrackerDismissButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Кнопка создания трекера
    private lazy var habbitTrackerCreate: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.accessibilityIdentifier = "habbitTrackerCreate"
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(habitTrackerCreateButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.accessibilityIdentifier = "HabitVC"
        view.backgroundColor = .white
        
        createView()
      }

    private func createView() {
        let habbitButtonsStack = UIStackView(arrangedSubviews: [habbitTrackerDismiss, habbitTrackerCreate])
        habbitButtonsStack.axis = .horizontal
        habbitButtonsStack.alignment = .fill
        habbitButtonsStack.distribution = .fillEqually
        habbitButtonsStack.spacing = 8
        
        habbitPropertiesTableView.delegate = self
        habbitPropertiesTableView.dataSource = self
        
        habbitCollectionView.delegate = self
        habbitCollectionView.dataSource = self
        habbitCollectionView.register(HabbitCollectionViewCell.self, forCellWithReuseIdentifier: "habbitCell")
        habbitCollectionView.register(HabbitCellSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        view.addSubview(viewControllerName)
        view.addSubview(habbitScrollView)
        habbitScrollView.addSubview(habbitContentView)
        habbitContentView.addSubview(habbitName)
        habbitContentView.addSubview(maxTrackerLength)
        habbitContentView.addSubview(habbitPropertiesTableView)
        habbitContentView.addSubview(habbitCollectionView)
        habbitContentView.addSubview(habbitButtonsStack)
        habbitButtonsStack.translatesAutoresizingMaskIntoConstraints = false
  
        
        NSLayoutConstraint.activate([
            viewControllerName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            viewControllerName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            habbitScrollView.topAnchor.constraint(equalTo: viewControllerName.bottomAnchor, constant: 24),
            habbitScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            habbitScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            habbitScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            habbitContentView.topAnchor.constraint(equalTo: habbitScrollView.topAnchor),
            habbitContentView.leadingAnchor.constraint(equalTo: habbitScrollView.leadingAnchor),
            habbitContentView.trailingAnchor.constraint(equalTo: habbitScrollView.trailingAnchor),
            habbitContentView.bottomAnchor.constraint(equalTo: habbitScrollView.bottomAnchor),
            habbitContentView.widthAnchor.constraint(equalTo: habbitScrollView.widthAnchor),
            
            habbitName.topAnchor.constraint(equalTo: habbitContentView.topAnchor, constant: 24),
            habbitName.centerXAnchor.constraint(equalTo: habbitContentView.centerXAnchor),
            habbitName.leadingAnchor.constraint(equalTo: habbitContentView.leadingAnchor, constant: 16),
            habbitName.trailingAnchor.constraint(equalTo: habbitContentView.trailingAnchor, constant: -16),
            habbitName.heightAnchor.constraint(equalToConstant: 75),
            
            maxTrackerLength.topAnchor.constraint(equalTo: habbitName.bottomAnchor),
            maxTrackerLength.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            maxTrackerLength.heightAnchor.constraint(equalToConstant: 22),
            
            habbitPropertiesTableView.topAnchor.constraint(equalTo: habbitName.bottomAnchor, constant: 24),
            habbitPropertiesTableView.centerXAnchor.constraint(equalTo: habbitContentView.centerXAnchor),
            habbitPropertiesTableView.leadingAnchor.constraint(equalTo: habbitContentView.leadingAnchor, constant: 16),
            habbitPropertiesTableView.trailingAnchor.constraint(equalTo: habbitContentView.trailingAnchor, constant: -16),
            habbitPropertiesTableView.heightAnchor.constraint(equalToConstant: 150),
            
            habbitCollectionView.topAnchor.constraint(equalTo: habbitPropertiesTableView.bottomAnchor, constant: 32),
            habbitCollectionView.leadingAnchor.constraint(equalTo: habbitContentView.leadingAnchor),
            habbitCollectionView.trailingAnchor.constraint(equalTo: habbitContentView.trailingAnchor),
            habbitCollectionView.bottomAnchor.constraint(equalTo: habbitPropertiesTableView.bottomAnchor, constant: 492),
            
            habbitButtonsStack.topAnchor.constraint(equalTo: habbitCollectionView.bottomAnchor, constant: 16),
            habbitButtonsStack.leadingAnchor.constraint(equalTo: habbitContentView.leadingAnchor, constant: 16),
            habbitButtonsStack.trailingAnchor.constraint(equalTo: habbitContentView.trailingAnchor, constant: -16),
            habbitButtonsStack.bottomAnchor.constraint(equalTo: habbitContentView.bottomAnchor),
            habbitButtonsStack.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc func habitTrackerDismissButtonPressed() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func habitTrackerCreateButtonPressed() {
        guard let name = habbitName.text else { return }
        guard !name.isEmpty else { return }
        guard let color = selectedColor else { return }
        guard let emoji = selectedEmoji else { return }
        
        let newTracker = Tracker(id: UUID(), trackerName: name, trackerColor: color, trackerEmoji: emoji, trackerShedule: schedule)
        delegate?.addTracker(tracker: newTracker)
        print("СОЗДАН ТРЕКЕР С НОМЕРОМ \(newTracker.id), ИМЕНЕМ \(name), ЦВЕТОМ \(color), ЭМОДЗИ \(emoji), ДНЯМИ НЕДЕЛИ \(newTracker.trackerShedule)")
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func newTrackerName(_ sender: UITextField) {
        blockButtons()
    }
    
    /// Функция блокировки кнопок создания трекера в случае если поля не заполнены
    private func blockButtons() {
        guard let trackerName = habbitName.text else { return }
        
        if trackerName.isEmpty == false && selectedCategory != "" &&
            selectedSchedule != "" && selectedEmoji != "" &&
            selectedColor != nil && trackerName.count < 38 {
            habbitTrackerCreate.isEnabled = true
            habbitTrackerCreate.backgroundColor = .black
        } else {
            habbitTrackerCreate.isEnabled = false
            habbitTrackerCreate.backgroundColor = .gray
        }
        if trackerName.count > 38 {
            maxTrackerLength.isHidden = false
        } else {
            maxTrackerLength.isHidden = true
        }
    }
}


extension HabitViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Properties cell")
        
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true
        
        if indexPath.row == 0 {
            let trackerCategory = selectedCategory ?? ""
            cell.textLabel?.text = "Категория"
            cell.detailTextLabel?.text = trackerCategory
            cell.detailTextLabel?.textColor = .gray
        } else if indexPath.row == 1 {
            let trackerSchedule = selectedSchedule ?? ""
            cell.textLabel?.text = "Расписание"
            cell.detailTextLabel?.text = trackerSchedule
            cell.detailTextLabel?.textColor = .gray
            
            if indexPath.row == 1 {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
                cell.layoutMargins = .zero
            } else {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
                cell.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 75
        }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            let controller = HabitScheduleViewController()
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        }
        else {
            let controller = HabitCategoryViewController()
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
}

extension HabitViewController: UITextFieldDelegate {
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

extension HabitViewController: UICollectionViewDataSource {
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
        guard let habbitCell = habbitCollectionView.dequeueReusableCell(withReuseIdentifier: "habbitCell", for: indexPath) as? HabbitCollectionViewCell else {return UICollectionViewCell() }
        
        habbitCell.collectionLable.text = ""
        habbitCell.collectionLable.backgroundColor = .clear
        
        if indexPath.section == 0 {
            let emoji = trackerEmoji.trackerEmoji[indexPath.item]
            habbitCell.collectionLable.text = emoji
            
            
            if selectedEmojiIndex == indexPath {
                habbitCell.contentView.backgroundColor = .lightGray
                habbitCell.contentView.layer.cornerRadius = 16
            } else {
                habbitCell.contentView.backgroundColor = .clear
                habbitCell.layer.borderColor = UIColor.clear.cgColor
                habbitCell.layer.borderWidth = 0
            }
        } else {
            let color = trackerColors.trackerBackgroundColors[indexPath.item]
            habbitCell.collectionLable.backgroundColor = color
        
            if selectedColorIndex == indexPath {
                habbitCell.layer.cornerRadius = 8
                habbitCell.layer.borderColor = color.withAlphaComponent(0.3).cgColor
                habbitCell.layer.borderWidth = 3
            } else {
                habbitCell.contentView.backgroundColor = .clear
                habbitCell.layer.borderColor = UIColor.clear.cgColor
                habbitCell.layer.borderWidth = 0
            }
        }
        return habbitCell
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
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! HabbitCellSupplementaryView // 6
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
            habbitCollectionView.reloadData()
            blockButtons()
        } else {
            selectedColorIndex = indexPath
            selectedColor = trackerColors.trackerBackgroundColors[indexPath.item]
            habbitCollectionView.reloadData()
            blockButtons()
        }
    }
}

/// Параметры расположения ячеек
extension HabitViewController: UICollectionViewDelegateFlowLayout {
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

extension HabitViewController: ScheduleViewControllerDelegate {
    func newSchedule(schedule: [Days]) {
        self.schedule = schedule
        selectedSchedule = shortDaysText(days: schedule)
        blockButtons()
        habbitPropertiesTableView.reloadData()
    }
    
    func shortDaysText(days: [Days]) -> String {
        let shortDays = days.map {$0.shortDay}
        let shortDaysText = shortDays.joined(separator: ", ")
        return shortDaysText
    }
}

extension HabitViewController: CategoryViewControllerDelegate {
    func newCategory(category: String) {
        self.selectedCategory = category
        blockButtons()
        habbitPropertiesTableView.reloadData()
    }
    
    
}
    
