// Стартовый контроллер создания и просмотра трекеров
import UIKit

final class TrackerViewController: UIViewController, UITextFieldDelegate, UISearchBarDelegate {
    
    // Заголовок
    private let viewControllerName: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    // Кнопка плюс
    private let plusTrackerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.accessibilityIdentifier = "plusTrackerButton"
        button.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
        return button
    }()
    
    //Пикер даты
    private let currentDate = UIDatePicker()
    
    
    //  Поле поиска
//    private let trackerSearchField = UISearchTextField()
    private let trackerSearchField = UISearchBar()
    
    //Трекер или заглушка для пустого экрана
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "TrackerViewController"
        view.backgroundColor = .white
        addTrackerTitle()
        //        addTrackerPlusButton()
        
        self.setNavigationBar()
        
        trackerSearchField.delegate = self
        
        view.addSubview(trackerSearchField)
        trackerSearchField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trackerSearchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerSearchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150)
        ])
        
        
    }
    
    
    func setNavigationBar() {
        view.addSubview(plusTrackerButton)
        plusTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(currentDate)
        currentDate.translatesAutoresizingMaskIntoConstraints = false
        currentDate.accessibilityIdentifier = "currentDatePicker"
        
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 88, width: screenSize.width, height: 42))
        let navItem = UINavigationItem(title: "Тест")
        let plusItem = UIBarButtonItem(customView: plusTrackerButton)
        navItem.leftBarButtonItem = plusItem
        let datePickerItem = UIBarButtonItem(customView: currentDate)
        navItem.rightBarButtonItem = datePickerItem
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }
    
    @objc func plusButtonPressed() {
        let controller = TrackerCreationViewController()
              self.present(controller, animated: true, completion: nil)
        
        
    }
    
    @objc func done() { // remove @objc for Swift 3
        
    }
    
    
    private func addTrackerTitle() {
        view.addSubview(viewControllerName)
        viewControllerName.translatesAutoresizingMaskIntoConstraints = false
        viewControllerName.font = UIFont.systemFont(ofSize: 41, weight: .bold)
        viewControllerName.text = "Трекер"
        NSLayoutConstraint.activate([
            viewControllerName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            viewControllerName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 88)
        ])
    }
    
    private func addTrackerPlusButton() {
        view.addSubview(plusTrackerButton)
        plusTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        plusTrackerButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusTrackerButton.accessibilityIdentifier = "plusTrackerButton"
        
        var plusBarTrackerButton = UIBarButtonItem(customView: plusTrackerButton)
        self.navigationItem.leftBarButtonItem = plusBarTrackerButton
        
    }
    
    
    
}
