//
//  HabitsViewController.swift
//  Tracker
//
//  Created by Максим Жуин on 14.10.2023.
//

import UIKit

class HabitsViewController: UIViewController {

    // MARK: -Properties

    let detailVC = HabitsDetailViewController()
    var selectedHabit: Habit?
    var progressCell: UICollectionViewCell?
    let notificationCenter = NotificationCenter.default

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: HabitCollectionViewCell.id)
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: ProgressCollectionViewCell.id)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private lazy var uiScrollView: UIScrollView = {
        let uiScrollView = UIScrollView()
        uiScrollView.translatesAutoresizingMaskIntoConstraints = false
        uiScrollView.showsVerticalScrollIndicator = true
        uiScrollView.isScrollEnabled = true
        uiScrollView.contentMode = .center
        return uiScrollView
    }()


    // MARK: -LifeCycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "Сегодня"
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.reloadData()
        notificationCenter.addObserver(self, selector: #selector(updateProgressCell(_:)), name: NSNotification.Name("progress"), object: nil)
        notificationCenter.addObserver(self, selector: #selector(updateProgressCell(_:)), name: NSNotification.Name("NewHabbit"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = mainBackgroundColor
        navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .init(systemName: "plus"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(buttonPressed(_:))
        )
        navigationItem.rightBarButtonItem?.width = 44
        navigationItem.rightBarButtonItem?.tintColor = purpleUIColor
        setupUI()
    }

    // MARK: -Functions
    @objc func buttonPressed(_ sender: UIBarButtonItem) {
        state = .create
        let habitVC = HabitViewController()
        let navigationVC = UINavigationController(rootViewController: habitVC)
        navigationVC.modalPresentationStyle = .fullScreen
        navigationController!.present(navigationVC, animated: true)
    }

    private func setupUI() {
        view.addSubview(collectionView)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 22),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -17),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }

    @objc func updateProgressCell(_ notification: Notification) {
        if let newCell = self.progressCell as? ProgressCollectionViewCell {
            newCell.updateStatus()
        }
    }
}


extension HabitsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return HabitsStore.shared.habits.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.id, for: indexPath) as? ProgressCollectionViewCell else { return UICollectionViewCell() }
            cell.backgroundColor = .white
            self.progressCell = cell
            return cell
           }  else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCollectionViewCell.id, for: indexPath) as? HabitCollectionViewCell else { return UICollectionViewCell() }
            let dataSource = HabitsStore.shared.habits[indexPath.row]
            cell.configureWith(dataSource)
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 8
            cell.updateStatus()
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: 343, height: 60)
        } else {
            return CGSize(width: 343, height: 130)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 18, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedHabit = HabitsStore.shared.habits[indexPath.row]
        detailVC.configure(with: self.selectedHabit!)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
