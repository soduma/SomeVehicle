//
//  FavoriteViewController.swift
//  SomeVehicle
//
//  Created by 장기화 on 2022/07/25.
//

import UIKit
import SnapKit
import CoreLocation

protocol FavoriteViewControllerDelegate: AnyObject {
    func tapDismissButton(zone: FavoriteZone)
}

class FavoriteViewController: UIViewController {
    weak var delegate: FavoriteViewControllerDelegate?
    private var favoriteZoneList: [FavoriteZone] = []
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic24_close"), for: .normal)
        button.addTarget(self, action: #selector(tapCloseButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var favoriteSocarZoneLabel: UILabel = {
        let label = UILabel()
        label.text = "즐겨찾는 존"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private lazy var favoriteTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        view.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.identifier)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        loadSavedZone()
    }
    
    @objc private func tapCloseButton() {
        dismiss(animated: true)
    }
    
    private func setLayout() {
        view.backgroundColor = .systemBackground
        
        [closeButton, favoriteSocarZoneLabel, favoriteTableView]
            .forEach { view.addSubview($0) }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(14)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(40)
        }
        
        favoriteSocarZoneLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(112)
            $0.leading.equalTo(24)
            $0.trailing.equalToSuperview()
        }
        
        favoriteTableView.snp.makeConstraints {
            $0.top.equalTo(favoriteSocarZoneLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func loadSavedZone() {
        if let savedData = UserDefaults.standard.object(forKey: "favoriteZoneList") as? Data {
            if let savedObject = try? JSONDecoder().decode([FavoriteZone].self, from: savedData) {
//                print(savedObject)
                favoriteZoneList = savedObject
            }
        }
    }
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteZoneList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier, for: indexPath) as? FavoriteTableViewCell else { return UITableViewCell() }
        cell.update(zone: favoriteZoneList[indexPath.row], zoneList: favoriteZoneList)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let zone = favoriteZoneList[indexPath.row]
        delegate?.tapDismissButton(zone: zone)
        dismiss(animated: true)
    }
}
