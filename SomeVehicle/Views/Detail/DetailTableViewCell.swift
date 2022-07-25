//
//  DetailTableViewCell.swift
//  SomeVehicle
//
//  Created by 장기화 on 2022/07/25.
//

import UIKit
import SnapKit
import Kingfisher

class DetailTableViewCell: UITableViewCell {
    static let identifier = "DetailTableViewCell"
    private var isLastCar = false
    
    private lazy var carImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel])
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
        
        [carImageView, stackView, dividerView]
            .forEach { contentView.addSubview($0) }
        
        carImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        stackView.snp.makeConstraints {
            $0.centerY.equalTo(carImageView)
            $0.leading.equalTo(carImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview()
        }
        
        makeDividerView()
    }
    
    func update(car: Car, carList: [Car]) {
        let imageURL = URL(string: car.imageUrl)
        carImageView.kf.setImage(with: imageURL)
        nameLabel.text = car.name
        descriptionLabel.text = car.description
        
        var list = carList
        if car == list.popLast() {
            isLastCar = true
        } else {
            isLastCar = false
        }
    }
    
    private func makeDividerView() {
        if !isLastCar {
            dividerView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.height.equalTo(1)
            }
        }
    }
}
