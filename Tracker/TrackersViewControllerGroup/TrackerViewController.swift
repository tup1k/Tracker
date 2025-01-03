// Стартовый контроллер создания и просмотра трекеров
import UIKit
import YandexMobileMetrica


final class TrackerViewController: UIViewController, UITextFieldDelegate, UISearchBarDelegate {
    var trackers: [Tracker] = []
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var completedTrackersID = Set<UUID>()
    var categoryName:[String] = []
    var visibleTrackersWithCategory: [TrackerCategory] = []
    var visibleTrackers: [Tracker] = []
    var visibleCategories: [TrackerCategory] = []
    private(set) var  pinedCategories: [TrackerCategory] = []
    private var pinnedTrackers: [Tracker] = []
    var selectedFilter: Int = 0
    private var isFiltered: Bool = false
    let trackerStore = TrackerStore.shared
    let trackerCategoryStore = TrackerCategoryStore.shared
    let trackerRecordStore = TrackerRecordStore.shared
    let analyticsService = AnalyticsService()
    let localizedPinnedTrackerCategory = NSLocalizedString("pinnedTrackerCategory", comment: "")
   
    /// Кнопка выбора даты
    private lazy var pickerDate: UIDatePicker = {
       let datePicker = UIDatePicker()
        datePicker.accessibilityIdentifier = "currentDatePicker"
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.backgroundColor = .ypDatePicker
        datePicker.layer.cornerRadius = 8
        datePicker.layer.masksToBounds = true
        return datePicker
    }()
    
    ///  Поле поиска
    private lazy var trackerSearchField: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        let localizedFindTrackerPlaceholder = NSLocalizedString("findTrackerPlaceholder", comment: "")
        search.searchBar.placeholder = localizedFindTrackerPlaceholder
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
        let localizedTrackerPlaceholderTitle = NSLocalizedString("trackerPlaceholder", comment: "")
        label.text = localizedTrackerPlaceholderTitle
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
        let localizedSearchPlaceholderLabel = NSLocalizedString("searchPlaceholderLabel", comment: "")
        label.text = localizedSearchPlaceholderLabel
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
//        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(TrackerCellViewController.self, forCellWithReuseIdentifier: "trackerCell")
        collectionView.register(TrackerCellSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .ypWhite
        collectionView.bounces = true
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    var currentDate: Date? {
        let selectedDate = pickerDate.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" // Формат даты
        dateFormatter.locale = Locale.current
        let formattedDate = dateFormatter.string(from: selectedDate)
        return dateFormatter.date(from: formattedDate) ?? Date()
    }
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        let localizedFilterButtonLabel = NSLocalizedString("filterButtonLabel", comment: "")
        button.setTitle(localizedFilterButtonLabel, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.backgroundColor = .ypBlue
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(filterButtonTaped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AnalyticsService.openScreenReport(screen: .main)
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AnalyticsService.closeScreenReport(screen: .main)
    }
 
    /// Настройки навибара
    private func setNavigationBar() {
        let localizedTrackerTitle = NSLocalizedString("trackersAppTitle", comment: "")
        let naviBarLeftButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(plusButtonPressed))
        naviBarLeftButton.tintColor = .ypBlack
        self.navigationItem.leftBarButtonItem = naviBarLeftButton
        
        let naviBarRightButton = UIBarButtonItem(customView: pickerDate)
        self.navigationItem.rightBarButtonItem = naviBarRightButton
        
        self.navigationItem.title = localizedTrackerTitle
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
        view.addSubview(filterButton)
        
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
            
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func currentCategoriesView() {
        let currentDate = pickerDate.date
        let calendar = Calendar.current
        
        let toDay = calendar.startOfDay(for: currentDate)
        
        var currentWeekDay = calendar.component(.weekday, from: currentDate)
        currentWeekDay = (currentWeekDay + 5) % 7
        
        visibleCategories = []
        pinnedTrackers = []
        
        for category in categories {
            let categoryTrackers = category.categoryTrackers
            let filteredCategoryTrackers = categoryTrackers.filter { tracker in
                let isCompletedToday = trackerRecordStore.importCoreDataRecordComplete(id: tracker.id , trackerDate: toDay)
                let isWeekdayMatch = tracker.trackerShedule.contains(Days.allCases[currentWeekDay])
                let isTrackerPinned = tracker.pinned
                
                switch selectedFilter {
                case 1:
                    filterButton.backgroundColor = .ypBlue
                    return isWeekdayMatch && !isTrackerPinned
                case 2:
                    filterButton.backgroundColor = .ypRed
                    return  isWeekdayMatch && isCompletedToday && !isTrackerPinned
                case 3:
                    filterButton.backgroundColor = .ypRed
                    return isWeekdayMatch && !isCompletedToday && !isTrackerPinned
                default:
                    filterButton.backgroundColor = .ypBlue
                    return isWeekdayMatch && !isTrackerPinned
                }
            }
            
            if !filteredCategoryTrackers.isEmpty {
                let filteredData = TrackerCategory(categoryName: category.categoryName, categoryTrackers: filteredCategoryTrackers)
                visibleCategories.append(filteredData)
            }
            
            let pinnedCategoryTrackers = categoryTrackers.filter { tracker in
                let isCompletedToday = trackerRecordStore.importCoreDataRecordComplete(id: tracker.id , trackerDate: toDay)
                let isWeekdayMatch = tracker.trackerShedule.contains(Days.allCases[currentWeekDay])
                let isTrackerPinned = tracker.pinned
                
                switch selectedFilter {
                case 2:
                    return isWeekdayMatch && isTrackerPinned && isCompletedToday
                case 3:
                    return isWeekdayMatch && isTrackerPinned && !isCompletedToday
                default:
                    return isWeekdayMatch && isTrackerPinned
                }
            }
            pinnedTrackers.append(contentsOf: pinnedCategoryTrackers)
        }
            
            if !pinnedTrackers.isEmpty {
                let pinnedCategory = TrackerCategory(categoryName: localizedPinnedTrackerCategory, categoryTrackers: pinnedTrackers)
                visibleCategories.insert(pinnedCategory, at: 0)
            }
            
            trackerCollectionView.reloadData()
            
            if visibleCategories.isEmpty && !isFiltered {
                filterButton.isHidden = true
            } else {
                filterButton.isHidden = false
            }
            placeholderVisible()
    }
    
    /// Функция отображения заглушки
    private func placeholderVisible() {
        let emptyVisibleTrackers: Bool = visibleCategories.isEmpty
        
        if isFiltered {
            searchPlaceholderImage.isHidden = !emptyVisibleTrackers
            searchPlaceholderLabel.isHidden = !emptyVisibleTrackers
            trackerCollectionView.isHidden = emptyVisibleTrackers
        } else {
            trackerPlaceholderImage.isHidden = !emptyVisibleTrackers
            trackerPlaceholderLabel.isHidden = !emptyVisibleTrackers
            trackerCollectionView.isHidden = emptyVisibleTrackers
        }
    }
    
    /// Функция нажатие кнопки +
    @objc private func plusButtonPressed() {
        let controller = TrackerCreationViewController()
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
        AnalyticsService.addTrackReport()
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
    
    @objc private func filterButtonTaped() {
        let controller = FilterViewController()
        controller.selectedFilter = selectedFilter
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
        AnalyticsService.filterTrackReport()
    }
}

/// Параметры ячейки и хедера
extension TrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].categoryTrackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as? TrackerCellViewController else { return UICollectionViewCell()}
        
        cell.backgroundColor = .ypWhite
        let tracker = visibleCategories[indexPath.section].categoryTrackers[indexPath.row]
        let isCompletedToday = trackerRecordStore.importCoreDataRecordComplete(id: tracker.id, trackerDate: currentDate ?? Date())
        
        cell.trackerDone = isCompletedToday
        cell.currentDate = currentDate ?? Date()
        cell.configure(with: tracker, isCompletedToday: isCompletedToday, isPinned: tracker.pinned)
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
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? TrackerCellSupplementaryView else { fatalError("Нет хэдера")
        }
        
        if indexPath.section == 0 && pinnedTrackers.count > 0 {
            view.titleLabel.text = localizedPinnedTrackerCategory
        } else {
            view.titleLabel.text = visibleCategories[indexPath.section].categoryName
        }
       
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
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  visibleCategories.count
    }
    
    func completedTrackersCount(trackerID: UUID) -> Int {
        return completedTrackers.filter { $0.id == trackerID }.count
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else {
            return nil
        }
        
        let indexPath = indexPaths[0]
        let thisTracker = visibleCategories[indexPath.section].categoryTrackers[indexPath.item]
        
        return UIContextMenuConfiguration(actionProvider: { actions in
            let localizedContextMenuPin = NSLocalizedString("contextMenuPin", comment: "")
            let localizedContextMenuUnpin = NSLocalizedString("contextMenuUnpin", comment: "")
            let localizedContextMenuEdit = NSLocalizedString("contextMenuEdit", comment: "")
            let localizedContextMenuDelete = NSLocalizedString("contextMenuDelete", comment: "")
            
            let pinTracker = UIAction(title: thisTracker.pinned ? localizedContextMenuUnpin : localizedContextMenuPin,
                     image: UIImage(systemName: "pin")) { [self] action in
           
                if thisTracker.pinned {
                    self.trackerStore.unPinTracker(trackerID: thisTracker.id)
                } else {
                    self.trackerStore.pinTracker(trackerID: thisTracker.id)
                }
                self.categories = (try? self.trackerCategoryStore.importCategoryWithTrackersFromCoreData()) ?? []
                self.currentCategoriesView()
                self.placeholderVisible()
                self.trackerCollectionView.reloadData()
            }
            
            let editTracker =
            UIAction(title: localizedContextMenuEdit,
                     image: UIImage(systemName: "pencil")) { action in
                self.editTracker(indexPath: indexPath)
                AnalyticsService.contextEditTrackerReport()
            }
            
            let deleteAction =
            UIAction(title: localizedContextMenuDelete,
                     image: UIImage(systemName: "trash"),
                     attributes: .destructive) { action in
                
                self.deleteTracker(indexPath: indexPath)
                AnalyticsService.contextDeleteTrackerReport()
            }
            
            return UIMenu(title: "", children: [pinTracker, editTracker, deleteAction])
        })
    }
     
    private func editTracker(indexPath: IndexPath) {
        let trackerToEdit = visibleCategories[indexPath.section].categoryTrackers[indexPath.item]
        let trackerCategoryToEdit = visibleCategories[indexPath.section].categoryName
        let controller = EditTrackerViewController(editedTracker: trackerToEdit, editedCategory: trackerCategoryToEdit)
        controller.delegate = self
        controller.editedTracker = trackerToEdit
        print(visibleCategories[indexPath.section].categoryTrackers[indexPath.item].trackerColor)
        controller.trackerType = trackerToEdit.trackerType
        self.present(controller, animated: true, completion: nil)
    }
    
    private func deleteTracker(indexPath: IndexPath) {
        showDeleteAlert(indexPath: indexPath)
    }
    
    private func showDeleteAlert(indexPath: IndexPath) {
        let trackerID = visibleCategories[indexPath.section].categoryTrackers[indexPath.item].id
        
        let localizedContextDeleteQuestion = NSLocalizedString("contextDeleteQuestion", comment: "")
        let localizedContextDeleteButton = NSLocalizedString("contextMenuDelete", comment: "")
        let localizedContextCancelButton = NSLocalizedString("cancelButton", comment: "")
        
        let alert = UIAlertController(title: localizedContextDeleteQuestion, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: localizedContextDeleteButton,
                                      style: .destructive,
                                      handler: { [weak self] _ in
            
            guard let self else { return }
            self.visibleCategories.removeAll{$0.categoryTrackers.contains(where: {$0.id == trackerID})}
            try? self.trackerStore.deleteTrackerFromCoreData(trackerID: trackerID)
            
            self.categories = (try? self.trackerCategoryStore.importCategoryWithTrackersFromCoreData()) ?? []
            self.currentCategoriesView()
            self.placeholderVisible()
            self.trackerCollectionView.reloadData()
            
        }))
        alert.addAction(UIAlertAction(title: localizedContextCancelButton, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        print("ЦВЕТ НОВОГО ТРЕКЕРА \(tracker.trackerColor)")
        currentCategoriesView()
        placeholderVisible()
        trackerCollectionView.reloadData()
    }
}

extension TrackerViewController: EditTrackerViewControllerDelegate {
    func editTracker(category: String, tracker: Tracker) {
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

extension TrackerViewController: FilterViewControllerDelegate {
    func selectFilterType(filter: Int) {
        let actualFilter = filter
        let calendar = Calendar.current
        let toDay = calendar.startOfDay(for: Date())
        
        if actualFilter == 0 {
            selectedFilter = 0
            isFiltered = false
            categories = (try? trackerCategoryStore.importCategoryWithTrackersFromCoreData()) ?? []
        } else if actualFilter == 1 {
            pickerDate.date = toDay
            selectedFilter = 1
            isFiltered = false
            categories = (try? trackerCategoryStore.importCategoryWithTrackersFromCoreData()) ?? []
        } else {
            selectedFilter = actualFilter
            isFiltered = true
        }
        
        currentCategoriesView()
        placeholderVisible()
        trackerCollectionView.reloadData()
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



