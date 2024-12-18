// Стартовый контроллер создания и просмотра трекеров
import UIKit


final class TrackerViewController: UIViewController, UITextFieldDelegate, UISearchBarDelegate {
    var trackers: [Tracker] = []
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var completedTrackersID = Set<UUID>()
    var categoryName:[String] = []
    var visibleTrackersWithCategory: [TrackerCategory] = []
    var visibleTrackers: [Tracker] = []
    var visibleCategories: [TrackerCategory] = []
    
    let trackerStore = TrackerStore.shared
    let trackerCategoryStore = TrackerCategoryStore.shared
    let trackerRecordStore = TrackerRecordStore.shared
    
    /// Кнопка выбора даты
    private lazy var pickerDate: UIDatePicker = {
       let datePicker = UIDatePicker()
        datePicker.accessibilityIdentifier = "currentDatePicker"
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    ///  Поле поиска
    private lazy var trackerSearchField: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "Поиск"
        search.searchBar.tintColor = .ypBlack
        search.searchResultsUpdater = self
        search.delegate = self
        search.searchBar.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        return search
    }()
    
    /// Картинка для заглушки
    private lazy var trackerPlaceholderImage: UIImageView = {
        let image = UIImageView()
        let placeholder = UIImage.trackerPlaceholder
        image.image = placeholder
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    /// Текст для заглушки
    private lazy var trackerPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Картинка для заглушки поиска
    private lazy var searchPlaceholderImage: UIImageView = {
        let image = UIImageView()
        let placeholder = UIImage.searchPlaceholder
        image.image = placeholder
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isHidden = true
        return image
    }()
    
    /// Текст для заглушки поиска
    private lazy var searchPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Ничего не найдено"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    /// Коллекшн вью для трекеров
    private lazy var trackerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 9
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TrackerCellViewController.self, forCellWithReuseIdentifier: "trackerCell")
        collectionView.register(TrackerCellSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var currentDate: Date? {
        let selectedDate = pickerDate.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" // Формат даты
        let formattedDate = dateFormatter.string(from: selectedDate)
        return dateFormatter.date(from: formattedDate) ?? Date()
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        commonTrackerVCConstraint()
        
        categories = (try? trackerCategoryStore.importCategoryWithTrackersFromCoreData()) ?? []
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardSwitchOff))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        trackerCollectionView.dataSource = self
        trackerCollectionView.delegate = self
        
        currentCategoriesView()
    }
 
    /// Настройки навибара
    private func setNavigationBar() {
        let naviBarLeftButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(plusButtonPressed))
        naviBarLeftButton.tintColor = .ypBlack
        self.navigationItem.leftBarButtonItem = naviBarLeftButton
        
        let naviBarRightButton = UIBarButtonItem(customView: pickerDate)
        self.navigationItem.rightBarButtonItem = naviBarRightButton
        
        self.navigationItem.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.searchController = trackerSearchField
    
    }
    
    /// Привязка элементов к экрану
    private func commonTrackerVCConstraint() {
        view.accessibilityIdentifier = "TrackerViewController"
        view.backgroundColor = .ypWhite
        
        view.addSubview(trackerPlaceholderImage)
        view.addSubview(trackerPlaceholderLabel)
        view.addSubview(searchPlaceholderImage)
        view.addSubview(searchPlaceholderLabel)
        view.addSubview(trackerCollectionView)
        
        NSLayoutConstraint.activate([
            trackerPlaceholderImage.widthAnchor.constraint(equalToConstant: 80),
            trackerPlaceholderImage.heightAnchor.constraint(equalToConstant: 80),
            
            trackerPlaceholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackerPlaceholderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
           
            trackerPlaceholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackerPlaceholderLabel.topAnchor.constraint(equalTo: trackerPlaceholderImage.bottomAnchor, constant: 8),
            
            searchPlaceholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchPlaceholderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
           
            searchPlaceholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchPlaceholderLabel.topAnchor.constraint(equalTo: searchPlaceholderImage.bottomAnchor, constant: 8),
           
            trackerCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackerCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func currentCategoriesView() {
        let currentDate = pickerDate.date
        let calendar = Calendar.current
        var currentWeekDay = calendar.component(.weekday, from: currentDate)
        currentWeekDay = (currentWeekDay + 5) % 7
        
        visibleCategories = []
        
        categories.forEach {
            let visibleTracker = $0.categoryTrackers.filter({$0.trackerShedule.contains(Days.allCases[currentWeekDay])})
            if !visibleTracker.isEmpty {
                visibleCategories.append(TrackerCategory(categoryName: $0.categoryName, categoryTrackers: visibleTracker))
            }
        }
        
        trackerCollectionView.reloadData()
        placeholderVisible()
    }
    
    /// Функция отображения заглушки
    private func placeholderVisible() {
        let emptyVisibleTrackers: Bool = visibleCategories.isEmpty
        trackerPlaceholderImage.isHidden = !emptyVisibleTrackers
        trackerPlaceholderLabel.isHidden = !emptyVisibleTrackers
        trackerCollectionView.isHidden = emptyVisibleTrackers
    }
    
    /// Функция нажатие кнопки +
    @objc private func plusButtonPressed() {
        let controller = TrackerCreationViewController()
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    /// Выбор даты в пикере
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" // Формат даты
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
        currentCategoriesView()
    }
    
    @objc private func keyboardSwitchOff() {
        view.endEditing(true)
    }
}

/// Параметры ячейки и хедера
extension TrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].categoryTrackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as? TrackerCellViewController else { return UICollectionViewCell() }
        
        let tracker = visibleCategories[indexPath.section].categoryTrackers[indexPath.row]
        print("ИМЯ ТРЕКЕРА В КОЛЛЕКЦИИ: \(tracker.trackerName)")
        
        let isCompletedToday = trackerRecordStore.importCoreDataRecordComplete(id: tracker.id, trackerDate: currentDate ?? Date())
        
        cell.trackerDone = isCompletedToday
        cell.currentDate = currentDate ?? Date()
        cell.configure(with: tracker, isCompletedToday: isCompletedToday)
        cell.delegate = self
        
        if (currentDate ?? Date()) <= Date() {
            cell.checkTrackerButton.isEnabled = true
        } else {
            cell.checkTrackerButton.isEnabled = false
        }
        return cell
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
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! TrackerCellSupplementaryView // 6
        view.titleLabel.text = visibleCategories[indexPath.section].categoryName
        print("Наименование категории: \(categories[indexPath.section].categoryName)")
        return view
    }
}

/// Параметры расположения ячеек
extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { // 1
        return CGSize(width: (collectionView.bounds.width - 9) / 2, height: 148)   // 2
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)           // 5
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func completedTrackersCount(trackerID: UUID) -> Int {
        return completedTrackers.filter { $0.id == trackerID }.count
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else {
            return nil
        }
        
        let indexPath = indexPaths[0]
        return UIContextMenuConfiguration(actionProvider: { actions in
            
            let pinTracker =
            UIAction(title: NSLocalizedString("Закрепить", comment: ""),
                     image: UIImage(systemName: "pin")) { action in
                
                // TO DO
            }
            
            let editTracker =
            UIAction(title: NSLocalizedString("Редактировать", comment: ""),
                     image: UIImage(systemName: "pencil")) { action in
                // TO DO
            }
            
            let deleteAction =
            UIAction(title: NSLocalizedString("Удалить", comment: ""),
                     image: UIImage(systemName: "trash"),
                     attributes: .destructive) { action in
                // TO DO
            }
            
            return UIMenu(title: "", children: [pinTracker, editTracker, deleteAction])
        })
    }
}

extension TrackerViewController: TrackerCellDelegate {
    func completeTracker(_ trackerCell: TrackerCellViewController, id: UUID, trackerDone: Bool) {
        let calendar = Calendar.current
        let selectedDate = calendar.startOfDay(for: pickerDate.date)
        
        if trackerDone {
            completedTrackersID.insert(id)
            trackerRecordStore.saveRecordToCoreData(id: id, trackerDate: currentDate ?? Date())
            trackerCollectionView.reloadData()
        } else {
            completedTrackersID.remove(id)
            trackerRecordStore.deleteRecordFromCoreData(id: id, trackerDate: currentDate ?? Date())
            trackerCollectionView.reloadData()
        }
    }
}

extension TrackerViewController: AddNewTrackerViewControllerDelegate {
    func addTracker(category: String, tracker: Tracker) {
        categories = (try? trackerCategoryStore.importCategoryWithTrackersFromCoreData()) ?? []
        currentCategoriesView()
        placeholderVisible()
        trackerCollectionView.reloadData()
    }
}

extension TrackerViewController: TrackerCreationViewControllerDelegate {
    func didSelectHabbitType(trackerType: String) {
        
    }
    
    func didSelectUnregularType(trackerType: String) {
        
    }
}

extension TrackerViewController: UISearchControllerDelegate, UISearchResultsUpdating  {
    func updateSearchResults(for searchController: UISearchController) {
        var searchVisibleCategories:[TrackerCategory] = []
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            visibleCategories.forEach {
                let searchVisibleTracker = $0.categoryTrackers.filter({$0.trackerName.lowercased().contains(searchText.lowercased())})
                if !searchVisibleTracker.isEmpty {
                    searchVisibleCategories.append(TrackerCategory(categoryName: $0.categoryName, categoryTrackers: searchVisibleTracker))
                    visibleCategories = searchVisibleCategories
                }
            }
                if searchVisibleCategories.isEmpty {
                    trackerCollectionView.isHidden = true
                    searchPlaceholderImage.isHidden = false
                    searchPlaceholderLabel.isHidden = false
                }
        } else {
            trackerCollectionView.isHidden = false
            searchPlaceholderImage.isHidden = true
            searchPlaceholderLabel.isHidden = true
            currentCategoriesView()
        }
        trackerCollectionView.reloadData()
        view.endEditing(true)
    }
}

