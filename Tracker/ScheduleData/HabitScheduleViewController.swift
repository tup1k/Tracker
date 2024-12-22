//
//  HabitScheduleViewController.swift
//  Tracker
//
//  Created by Олег Кор on 10.11.2024.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func newSchedule (schedule: [Days])
}

final class HabitScheduleViewController: UIViewController {
    weak var delegate: ScheduleViewControllerDelegate?
    private var selectedDays: [Days] = []
    
    /// Заголовок расписания
    private lazy var scheduleTitle: UILabel = {
        let label = UILabel()
        let localizedScheduleTitle = NSLocalizedString("scheduleTitle", comment: "")
        label.text = localizedScheduleTitle
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Таблица с днями недели для трекера
    private lazy var scheduleTableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .ypBlack
        tableView.separatorInset.left = 16
        tableView.separatorInset.right = 16
        tableView.contentInset.top = -35
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "scheduleCell")
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()

    /// Кнопка задания расписания для привычки
    private lazy var createScheduleButton: UIButton = {
        let button = UIButton()
        let localizedScheduleCreateButton = NSLocalizedString("scheduleCreate", comment: "")
        button.setTitle(localizedScheduleCreateButton, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhite, for: .normal)
        button.backgroundColor = .ypBlack
        button.accessibilityIdentifier = "createScheduleButton"
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(scheduleButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.accessibilityIdentifier = "HabitScheduleVC"
        view.backgroundColor = .ypWhite
        
        createViewConstraint()
        
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        blockButton()
    }
    
    /// Привязки UI
    private func createViewConstraint() {
        view.addSubview(scheduleTitle)
        view.addSubview(scheduleTableView)
        view.addSubview(createScheduleButton)
        
        NSLayoutConstraint.activate([
            scheduleTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            scheduleTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            createScheduleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createScheduleButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            createScheduleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createScheduleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createScheduleButton.heightAnchor.constraint(equalToConstant: 60),
            
            scheduleTableView.topAnchor.constraint(equalTo: scheduleTitle.bottomAnchor, constant: 30),
            scheduleTableView.bottomAnchor.constraint(equalTo: createScheduleButton.topAnchor, constant: -47),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    /// Создание расписания для привычки
    @objc private func scheduleButtonPressed() {
            delegate?.newSchedule(schedule: selectedDays)
            print("ЗАДАНЫ СДЕЛУЮЩИЕ ДНИ НЕДЕЛИ ДЛЯ ТРЕКЕРА: \(selectedDays)")
            dismiss(animated: true, completion: nil)
    }
    
    private func blockButton() {
        if selectedDays.isEmpty {
            createScheduleButton.isEnabled = false
            createScheduleButton.backgroundColor = .ypGray
        } else {
            createScheduleButton.isEnabled = true
            createScheduleButton.backgroundColor = .ypBlack
        }
    }
}

extension HabitScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Days.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath)
        let weekDay = Days.allCases[indexPath.row].localizedName
        cell.textLabel?.text = weekDay
        cell.backgroundColor = .ypLightGray
        cell.selectionStyle = .none
        
        let dayToggle = UISwitch()
        cell.accessoryView = dayToggle
        dayToggle.onTintColor = .ypBlue
        dayToggle.addTarget(self, action: #selector(selectedDay), for: .valueChanged)
        dayToggle.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 7
    }
    
    @objc private func selectedDay(_ sender: UISwitch) {
        let day = Days.allCases[sender.tag]
        
        if sender.isOn {
            selectedDays.append(day)
            blockButton()
        } else {
            selectedDays.removeAll { $0 == day }
            blockButton()
        }
    }
}
