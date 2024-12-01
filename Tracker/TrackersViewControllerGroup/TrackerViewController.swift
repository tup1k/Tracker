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
        let search = UISearchController()
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
        mokTrackers()
        
        trackerCollectionView.dataSource = self
        trackerCollectionView.delegate = self
        
        currentTrackersView()
    }
    
    // Моковские трекеры для отладки
    func mokTrackers() {
        let mokTracker_1 = Tracker(id: UUID(), trackerName: "MOK Tracker_1", trackerColor: .red, trackerEmoji: "😻", trackerShedule: [.wednesday, .sutarday])
        let mokTracker_2 = Tracker(id: UUID(), trackerName: "MOK Tracker_2", trackerColor: .green, trackerEmoji: "😻", trackerShedule: [.friday])
        let mokTracker_3 = Tracker(id: UUID(), trackerName: "MOK Tracker_3_long edition for testing", trackerColor: .orange, trackerEmoji: "😻", trackerShedule: [.monday, .sutarday])
        trackers.append(mokTracker_1)
        trackers.append(mokTracker_2)
        trackers.append(mokTracker_3)
        
        let category_1 = TrackerCategory(categoryName: "Важное", categoryTrackers: [mokTracker_1, mokTracker_2, mokTracker_3])

        categories.append(category_1)
        categoryName.append(category_1.categoryName)
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
        view.addSubview(trackerCollectionView)
        
        NSLayoutConstraint.activate([
            trackerPlaceholderImage.widthAnchor.constraint(equalToConstant: 80),
            trackerPlaceholderImage.heightAnchor.constraint(equalToConstant: 80),
            
            trackerPlaceholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackerPlaceholderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
           
            trackerPlaceholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackerPlaceholderLabel.topAnchor.constraint(equalTo: trackerPlaceholderImage.bottomAnchor, constant: 8),
           
            trackerCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackerCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func currentTrackersView() {
        let currentDate = pickerDate.date
        let calendar = Calendar.current
        var currentWeekDay = calendar.component(.weekday, from: currentDate)
        currentWeekDay = (currentWeekDay + 5) % 7
        
        visibleTrackers = []
        
        for category in categories {
            for onetracker in category.categoryTrackers where (onetracker.trackerShedule.contains(Days.allCases[currentWeekDay]))  {
                visibleTrackers.append(onetracker)
            }
        }
        
        for one in visibleTrackers {
            print("Дата в трекере:\(one.trackerShedule) и \(Days.allCases[currentWeekDay])")
        }
        
        visibleTrackers = Array(visibleTrackers.reduce(into: [UUID: Tracker]()) { $0[$1.id] = $1 }.values)
        for tracker in visibleTrackers {
            print(tracker.trackerName)
        }
        
        print(visibleTrackers.count)
        trackerCollectionView.reloadData()
        placeholderVisible()
    }
    
    /// Функция отображения заглушки
    private func placeholderVisible() {
        if visibleTrackers.isEmpty {
            trackerPlaceholderImage.isHidden = false
            trackerPlaceholderLabel.isHidden = false
            trackerCollectionView.isHidden = true
        } else {
            trackerPlaceholderImage.isHidden = true
            trackerPlaceholderLabel.isHidden = true
            trackerCollectionView.isHidden = false
        }
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
        currentTrackersView()
    }
}

/// Параметры ячейки и хедера
extension TrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleTrackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as? TrackerCellViewController else { return UICollectionViewCell() }
        
        let tracker = visibleTrackers[indexPath.row]
        print("ИМЯ ТРЕКЕРА В КОЛЛЕКЦИИ: \(tracker.trackerName)")
        
        let isCompletedToday = completedTrackers.contains {
            $0.id == tracker.id && Calendar.current.isDate($0.trackerDate, inSameDayAs: currentDate ?? Date())
        }
        cell.trackerDone = isCompletedToday
        let completeTrackersCount = completedTrackers.filter { $0.id == tracker.id }.count
        cell.configure(with: tracker, completedCount: completeTrackersCount, isCompletedToday: isCompletedToday)
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
        view.titleLabel.text = categories[indexPath.section].categoryName
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
        return categories.count
    }
    
    func completedTrackersCount(trackerID: UUID) -> Int {
        return completedTrackers.filter { $0.id == trackerID }.count
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else {
            return nil
        }
        
        let indexPath = indexPaths[0]
        return UIContextMenuConfiguration(actionProvider: { actions in    // 4
            return UIMenu(children: [                                     // 5
                UIAction(title: "Редактировать") {  _ in                // 6
                    let alert = UIAlertController(title: "Внимание!",
                                                  message: "Данная функция доступна \nв платной версии",
                                                  preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                },
                                    ])
        })
    }
}

extension TrackerViewController: TrackerCellDelegate {
    func completeTracker(_ trackerCell: TrackerCellViewController, id: UUID, trackerDone: Bool) {
        let calendar = Calendar.current
        
        if trackerDone {
            completedTrackersID.insert(id)
            let trackerRecord = TrackerRecord(id: id, trackerDate: pickerDate.date)
            completedTrackers.append(trackerRecord)
            trackerCollectionView.reloadData()
            if !completedTrackers.contains(where: { $0.id == id && calendar.isDate($0.trackerDate, inSameDayAs: currentDate ?? Date()) }) {
                completedTrackers.append(trackerRecord)
            }
            print(completedTrackersID)
        } else {
            completedTrackersID.remove(id)
            if let index = completedTrackers.firstIndex(where: { $0.id == id && calendar.isDate($0.trackerDate, inSameDayAs: currentDate ?? Date()) }) {
                completedTrackers.remove(at: index)
                print(completedTrackersID)
            }
            trackerCollectionView.reloadData()
        }
    }
}

extension TrackerViewController: AddNewTrackerViewControllerDelegate {
    func addTracker(tracker: Tracker, selectedCategory: String) {
        print("ВЫ ПЕРЕДАЛИ В ОСНОВНОЙ КОНТРОЛЛЕР СЛЕДУЮЩИЙ ТРЕКЕР: \(tracker)")
        trackers.append(tracker)
        
        let newCategory = TrackerCategory(categoryName: selectedCategory, categoryTrackers: trackers)
        self.categories = [newCategory]
        
        trackerCollectionView.reloadData()
        currentTrackersView()
        placeholderVisible()
    }
}

extension TrackerViewController: TrackerCreationViewControllerDelegate {
    func didSelectHabbitType(type: String) {
        
    }
    
    func didSelectUnregularType(type: String) {
        
    }
}

extension TrackerViewController: UISearchControllerDelegate, UISearchResultsUpdating  {
    func updateSearchResults(for searchController: UISearchController) {
        print("Метод для поиска")
    }
}

