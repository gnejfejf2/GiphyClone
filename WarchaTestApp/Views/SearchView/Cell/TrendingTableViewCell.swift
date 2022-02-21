//
//  TrendingTableViewCell.swift
//  WarchaTestApp
//
//  Created by Hwik on 2022/02/21.
//

import UIKit

class TrendingCollectionViewCell: UICollectionViewCell {

    static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }
    
    
    let label : UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        return view
    }()
    
    let height : CGFloat = CGFloat.random(in: 1...500)
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        configure()
    }

   

 
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
 
    func addSubviews() {
        contentView.addSubview(label)
        
    }

    func configure() {
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        contentView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
    }
    
 
}
