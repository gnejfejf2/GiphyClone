//
//  HeaderCollectionReusableView.swift
//  WarchaTestApp
//
//  Created by Hwik on 2022/02/21.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }
    
    
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
        
        self.addSubview(label)
    }

    func configure() {
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
    }
}
