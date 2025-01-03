//
//  FilterViewController.swift
//  Tracker
//
//  Created by Олег Кор on 23.12.2024.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func selectFilterType(filter: Int)
}

final class FilterViewController: UIViewController {
    weak var delegate: FilterViewControllerDelegate?
    var selectedFilter: Int?
    private let filtersName: [String] = [NSLocalizedString("allTrackers", comment: ""), NSLocalizedString("todayTrackers", comment: ""), NSLocalizedString("finishedTrackers", comment: ""), NSLocalizedString("notFinishedTrackers", comment: "")]
    
    /// Заголовок
    private lazy var filterTitle: UILabel = {
        let label = UILabel()
        let localizedFilterTitle = NSLocalizedString("filterTitle", comment: "")
        label.text = localizedFilterTitle
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Таблица с категориями
    private lazy var filterTableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.isScrollEnabled = false
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorInset.left = 16
        tableView.separatorInset.right = 16
        tableView.separatorColor = .ypBlack
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "filterCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "filterVC"
        view.backgroundColor = .ypWhite
        
        filterTableView.dataSource = self
        filterTableView.delegate = self
        
        createView()
    }
    
    // Создание UI
    private func createView() {
        view.addSubview(filterTitle)
        view.addSubview(filterTableView)
        
        NSLayoutConstraint.activate([
            filterTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            filterTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            filterTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterTableView.topAnchor.constraint(equalTo: filterTitle.bottomAnchor, constant: 24),
            filterTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterTableView.heightAnchor.constraint(equalToConstant: 343),
        ])
    }
}
    
   
extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtersName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath)
        let typeOfFilter = filtersName[indexPath.row]
        cell.textLabel?.text = typeOfFilter
        cell.textLabel?.textColor = .ypBlack
        cell.backgroundColor = .ypAppBackground
        cell.selectionStyle = .none
        cell.accessoryType = (selectedFilter == indexPath.row) ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let numberOfFilter = indexPath.row
        tableView.reloadData()
        delegate?.selectFilterType(filter: numberOfFilter)
        self.dismiss(animated: true, completion: nil)
    }
}

        
        
        

