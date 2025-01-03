//
//  StatisticsCellViewController.swift
//  Tracker
//
//  Created by Олег Кор on 24.12.2024.
//
import UIKit

final class StatisticsCellViewController: UICollectionViewCell {
    static let identifier = "statisticsCell"
    
    private lazy var cellView: UIView = {
        let myView = UIView()
        myView.backgroundColor = .clear
        myView.layer.cornerRadius = 16
        myView.layer.masksToBounds = true
        myView.translatesAutoresizingMaskIntoConstraints = false
        myView.layer.borderWidth = 1
        myView.layer.borderColor = UIColor.ypRed.cgColor
        return myView
    }()
    
    lazy var statisticsCount: UILabel = {
        let label = UILabel()
        label.text = "6"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var statisticsType: UILabel = {
        let label = UILabel()
        label.text = "Лучший период"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        cellContraint()
        layoutSubviews()
    }
    
    private func cellContraint() {
        contentView.addSubview(cellView)
        cellView.addSubview(statisticsCount)
        cellView.addSubview(statisticsType)
        
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.heightAnchor.constraint(equalToConstant: 90),
            cellView.widthAnchor.constraint(equalToConstant: 343),
            
            statisticsCount.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 12),
            statisticsCount.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 12),
            statisticsCount.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -12),
            
            statisticsType.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -12),
            statisticsType.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 12),
            statisticsType.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -12),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
           
        let gradientLayer = CAGradientLayer()
        let firstColor = UIColor(red: 253/255.0, green: 76/255.0, blue: 73/255.0, alpha: 1.0)
        let secondColor = UIColor(red: 70/255.0, green: 230/255.0, blue: 157/255.0, alpha: 1.0)
        let thirdColor = UIColor(red: 0/255.0, green: 123/255.0, blue: 250/255.0, alpha: 1.0)
        
        gradientLayer.frame = contentView.bounds
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: 16).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 1
        
        gradientLayer.mask = shapeLayer
        
        contentView.layer.addSublayer(gradientLayer)

       }
}

