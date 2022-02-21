//
//  RecentTableViewCell.swift
//  WarchaTestApp
//
//  Created by Hwik on 2022/02/21.
//

import UIKit

class RecentCollectionViewCell: UICollectionViewCell {

    static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }
    
    let image : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "arrow.uturn.right")
        view.tintColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let label : UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        return view
    }()
    
  
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
        self.accessibilityScroll(.right)
        contentView.addSubview(label)
        contentView.addSubview(image)
    }

    func configure() {
        
        image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant : 15).isActive = true
        image.topAnchor.constraint(equalTo: contentView.topAnchor  , constant : 5).isActive = true
        image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor , constant: -5).isActive = true
        image.trailingAnchor.constraint(equalTo: label.leadingAnchor , constant: -15).isActive = true
        image.widthAnchor.constraint(equalTo : contentView.heightAnchor).isActive = true
        
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        contentView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
    }
}
