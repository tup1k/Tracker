// Стартовый контроллер создания и просмотра трекеров
import UIKit



final class TrackerViewController: UIViewController, UITextFieldDelegate, UISearchBarDelegate {
    
    var trackers: [Tracker] = []
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var activeTrackers: [TrackerRecord] = []
    
    /// Кнопка выбора даты
    private let currentDate: UIDatePicker = {
       let datePicker = UIDatePicker()
        datePicker.accessibilityIdentifier = "currentDatePicker"
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    ///  Поле поиска
    private let trackerSearchField: UISearchController = {
        let search = UISearchController()
        search.searchBar.placeholder = "Поиск"
        return search
    }()
    
    /// Картинка для заглушки
    private let trackerPlaceholderImage: UIImageView = {
        let image = UIImageView()
        let placeholder = UIImage.trackerPlaceholder
        image.image = placeholder
        return image
    }()
    
    /// Текст для заглушки
    private let trackerPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let trackerCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 9
        layout.minimumInteritemSpacing = 9
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        elementsConstraint()
        cellRegistration()
        mokTrackers()
        
        trackerCollectionView.dataSource = self
        trackerCollectionView.delegate = self
    }
    
    // Моковские трекеры для отладки
    private func mokTrackers() {
        let mokTracker_1 = Tracker(id: 1, trackerName: "MOK Tracker_1", trackerColor: .red, trackerEmoji: "", trackerShedule: [])
        let mokTracker_2 = Tracker(id: 2, trackerName: "MOK Tracker_2", trackerColor: .green, trackerEmoji: "", trackerShedule: [])
        let mokTracker_3 = Tracker(id: 2, trackerName: "MOK Tracker_3_long edition for testing", trackerColor: .orange, trackerEmoji: "", trackerShedule: [])
        trackers.append(mokTracker_1)
        trackers.append(mokTracker_2)
        trackers.append(mokTracker_3)
        
        let category_1 = TrackerCategory(categoryName: "Важное", categoryTrackers: [mokTracker_1])
        let category_2 = TrackerCategory(categoryName: "Потом", categoryTrackers: [mokTracker_2, mokTracker_3])
        categories.append(category_1)
        categories.append(category_2)
    }
    
    /// Настройки навибара
    private func setNavigationBar() {
        let naviBarLeftButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(plusButtonPressed))
        naviBarLeftButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = naviBarLeftButton
        
        let naviBarRightButton = UIBarButtonItem(customView: currentDate)
        self.navigationItem.rightBarButtonItem = naviBarRightButton
        
        self.navigationItem.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.searchController = trackerSearchField
    }
    
    /// Привязка элементов к экрану
    private func elementsConstraint() {
        view.accessibilityIdentifier = "TrackerViewController"
        view.backgroundColor = .white
        
        [trackerPlaceholderImage,
         trackerPlaceholderLabel,
         trackerCollectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
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
    
    /// Регистрация ячеек и хедера collectionview
    private func cellRegistration() {
        trackerCollectionView.register(TrackerCellViewController.self, forCellWithReuseIdentifier: "trackerCell")
        trackerCollectionView.register(TrackerCellSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    /// Нажатие кнопки +
    @objc func plusButtonPressed() {
        let controller = TrackerCreationViewController()
        self.present(controller, animated: true, completion: nil)
    }
    
    /// Выбор даты в пикере
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" // Формат даты
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
}

/// Параметры ячейки и хедера
extension TrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as? TrackerCellViewController
        
        cell?.titleLable.text = trackers[indexPath.row].trackerName
        cell?.cellView.backgroundColor = trackers[indexPath.row].trackerColor
        cell?.checkTrackerButton.backgroundColor = trackers[indexPath.row].trackerColor
        cell?.daysCountLable.text = "1 день"
        return cell!
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
        view.titleLabel.text = categories[indexPath.row].categoryName
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
    
}

extension TrackerViewController: UICollectionViewDelegate {
    
    
}
