import UIKit


class GifCollectionViewCell : UICollectionViewCell {
    static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }
    
    
    let imageView : UIImageView = {
        
      
        let imageView3 = UIImageView()
      
        imageView3.translatesAutoresizingMaskIntoConstraints = false
        return imageView3
    }()
    

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 2, height: 600))

        addSubviews()
        configure()
    }


    var item : Gif?

 
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
 
    func uiSetting(){
        guard let imageItem = item?.images?.original else { return }
        
        imageView.setGifUrl(imageItem.url)
 
 
    }
    
    func addSubviews() {
        self.accessibilityScroll(.right)
        contentView.addSubview(imageView)
        contentView.backgroundColor = .red
    }

    func configure() {
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        contentView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
}
