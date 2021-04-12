//
//  MainCell.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 19/02/2021.
//

import UIKit

class MainCell: UITableViewCell {
    
    static let identifier = "MainCell"
    let cellStyle = CellStyle.default
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 18.0)
        return titleLabel
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 14.0)
        label.textColor = .mainColor
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: cellStyle, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel: MainCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            titleLabel.text = viewModel.textLabelText
            subTitleLabel.text = viewModel.detailTextLabel
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            
            subTitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 8),
            subTitleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            
                    
        ])

    }
    
}
