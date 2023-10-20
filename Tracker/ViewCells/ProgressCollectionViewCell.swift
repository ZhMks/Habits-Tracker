//
//  ProgressCollectionViewCell.swift
//  Tracker
//
//  Created by Максим Жуин on 14.10.2023.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {

    // MARK: -Properties

    static let id = "ProgressCollectionViewCell"
    var number = 0

    private lazy var progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .bar)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.backgroundColor = .systemGray2
        progressBar.progressTintColor = UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1)
        progressBar.layer.cornerRadius = 4
        progressBar.progress = HabitsStore.shared.todayProgress
        progressBar.clipsToBounds = true
        return progressBar
    }()

    private lazy var progressText: UILabel = {
        let progressText = UILabel()
        progressText.textColor = .systemGray
        progressText.text = "Все получится!"
        progressText.translatesAutoresizingMaskIntoConstraints = false
        return progressText
    }()

    private lazy var percentage: UILabel = {
        let percentage = UILabel()
        let percent = Float(number) * HabitsStore.shared.todayProgress
        percentage.translatesAutoresizingMaskIntoConstraints = false
        percentage.text = "\(percent)%"
        percentage.textColor = .systemGray
        return percentage
    }()

    // MARK: -LifeCycle

    override init(frame: CGRect) {
           super.init(frame: frame)
           layer.cornerRadius = 8
           setupUI()
       }


       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

    // MARK: -Functions
    
        private func setupUI() {

            contentView.addSubview(progressBar)
            contentView.addSubview(progressText)
            contentView.addSubview(percentage)

            let safeArea = contentView.safeAreaLayoutGuide
            
            NSLayoutConstraint.activate([
                progressText.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
                progressText.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 12),
                progressText.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -32),
                progressText.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -115),


                progressBar.topAnchor.constraint(equalTo: progressText.bottomAnchor, constant: 10),
                progressBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 12),
                progressBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -12),
                progressBar.heightAnchor.constraint(equalToConstant: 7.0),
                progressBar.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -15),

                percentage.centerYAnchor.constraint(equalTo: progressText.centerYAnchor),
                percentage.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -12)

            ])
        }

    func updateStatus() {
        progressBar.progress = HabitsStore.shared.todayProgress
        number = Int(Float(100) * HabitsStore.shared.todayProgress)
        percentage.text = "\(number)%"
    }
}
