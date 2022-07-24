//
//  FavoriteTableViewCell.swift
//  SomeVehicle
//
//  Created by 장기화 on 2022/07/25.
//

import UIKit
import SnapKit

class FavoriteTableViewCell: UITableViewCell {
    static let identifier = "FavoriteTableViewCell"
    private var isLastZone = false
    
    private lazy var zoneImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var aliasLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [nameLabel, aliasLabel])
        view.axis = .vertical
        view.spacing = 4
        return view
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [zoneImageView, stackView, dividerView]
            .forEach { contentView.addSubview($0) }
        
        zoneImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.centerY.equalTo(zoneImageView)
            $0.leading.equalTo(zoneImageView.snp.trailing).offset(20)
        }
        
        makeDividerView()
    }
    
    func update(zone: FavoriteZone, zoneList: [FavoriteZone]) {
        zoneImageView.image = UIImage(named: "img_zone")
        nameLabel.text = zone.name
        aliasLabel.text = zone.alias
        
        var list = zoneList
        if zone == list.popLast() {
            isLastZone = true
        } else {
            isLastZone = false
        }
    }
    
    private func makeDividerView() {
        if !isLastZone {
            dividerView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.height.equalTo(1)
            }
        }
    }
}
