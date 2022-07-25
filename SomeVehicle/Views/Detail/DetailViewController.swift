//
//  DetailViewController.swift
//  SomeVehicle
//
//  Created by 장기화 on 2022/07/25.
//

import UIKit
import Alamofire
import SnapKit

class DetailViewController: UIViewController {
    private let zone: ZoneAnnotation
    private let networkManager = NetworkManager()
    private var headerCarList = [GroupedSection<String, Car>]()
    private var favoriteZoneList: [FavoriteZone] = []
    private var isFavoriteZone = false
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private lazy var aliasLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic24_favorite_gray"), for: .normal)
        button.setImage(UIImage(named: "ic24_favorite_black"), for: .highlighted)
        button.addTarget(self, action: #selector(tapFavoriteButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = .systemBackground
        view.showsVerticalScrollIndicator = false
        view.allowsSelection = false
        view.separatorStyle = .none
        view.contentInset.bottom = 64
        view.dataSource = self
        view.delegate = self
        view.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.identifier)
        return view
    }()
    
    init(zone: ZoneAnnotation) {
        self.zone = zone
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        checkIsFavoriteZone()
        
        Task {
            await fetchCar(zoneId: zone.id)
            tableView.reloadData()
        }
    }
    
    @objc private func tapFavoriteButton() {
        isFavoriteZone.toggle()
        
        let imageName = isFavoriteZone ? "ic24_favorite_blue" : "ic24_favorite_gray"
        favoriteButton.setImage(UIImage(named: imageName), for: .normal)
        
        if isFavoriteZone {
            if favoriteZoneList.firstIndex(where: { $0.id == zone.id }) == nil {
                let lati = String(zone.coordinate.latitude)
                let long = String(zone.coordinate.longitude)
                let zone = FavoriteZone(id: zone.id, name: zone.name, alias: zone.alias, latitude: lati, longitude: long)
                favoriteZoneList.insert(zone, at: 0)
            }
        } else {
            guard let index = favoriteZoneList.firstIndex(where: { $0.id == zone.id} ) else { return }
            favoriteZoneList.remove(at: index)
        }
        guard let data = try? JSONEncoder().encode(favoriteZoneList) else { return }
        UserDefaults.standard.set(data, forKey: "favoriteZoneList")
    }
    
    private func checkIsFavoriteZone() {
        if let savedData = UserDefaults.standard.object(forKey: "favoriteZoneList") as? Data {
            if let savedObject = try? JSONDecoder().decode([FavoriteZone].self, from: savedData) {
//                print(savedObject)
                favoriteZoneList = savedObject
                
                let alreadyFavoriteZone = favoriteZoneList.filter { $0.id == zone.id }
                if !alreadyFavoriteZone.isEmpty {
                    isFavoriteZone = true
                    favoriteButton.setImage(UIImage(named: "ic24_favorite_blue"), for: .normal)
                }
            }
        }
    }
    
    private func fetchCar(zoneId: String) async {
        let data = await networkManager.getCarsInZone(zone: zoneId)
        switch data {
        case .success(let car):
            headerCarList = GroupedSection.group(rows: car, by: { $0.newCatagory })
            headerCarList.sort { $0.sectionItem < $1.sectionItem }
//            print("🙏🏻\(headerCarList)")
            
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    private func setLayout() {
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        
        let backButtonImage = UIImage(named: "ic24_back")
        navigationController?.navigationBar.backIndicatorImage = backButtonImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        
        [nameLabel, aliasLabel, favoriteButton, tableView]
            .forEach { view.addSubview($0) }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.leading.equalToSuperview().inset(24)
        }
        
        aliasLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(nameLabel)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.trailing.equalToSuperview().inset(28)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(aliasLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        nameLabel.text = zone.name
        aliasLabel.text = zone.alias
    }
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerCarList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = headerCarList[section]
        return section.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as? DetailTableViewCell else { return UITableViewCell() }
        
        let list = headerCarList[indexPath.section].rows
        cell.update(car: list[indexPath.row], carList: list)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = headerCarList[section].sectionItem
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
        let label = UILabel(frame: CGRect(x: 0, y: 10, width: headerView.frame.width, height: headerView.frame.height))
        label.text = sectionHeader
        label.font = .systemFont(ofSize: 16, weight: .medium)
        headerView.addSubview(label)
        headerView.layoutIfNeeded()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
}
