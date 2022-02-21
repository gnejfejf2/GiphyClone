
import UIKit

@objc protocol UICollectionViewDelegateLayoutAttribute: AnyObject {
    func collectionView(_ collectionView: UICollectionView, forItemAt indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
    @objc optional func collectionView(_ collectionView: UICollectionView, kind: String, forSupplementary indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
}

protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath , cellWidth : CGFloat ) -> CGFloat
    //컬렉션 아이템의 갯수를 받아온다.
    func collectionView(_ collectionView: UICollectionView, rowOfSection section: Int) -> Int
    //아이템의 스크롤 방향을 결정한다
    func collectionView(_ collectionView: UICollectionView, scrollDirectionOfSection section: Int) -> UICollectionView.ScrollDirection
}

final class CustomLayout: UICollectionViewFlowLayout {

    enum Element: String {
        case sectionHeader
        case cell

        var id: String {
            return self.rawValue
        }

        var kind: String {
            return "Kind\(self.rawValue.capitalized)"
        }
    }

    override public var collectionViewContentSize: CGSize {
        return CGSize(width: collectionViewWidth, height: contentHeight)
    }

    // MARK: - Properties
    weak var delegate : PinterestLayoutDelegate?
 
    private var oldBounds = CGRect.zero
    private var contentHeight = CGFloat()
    private var cache = [Element: [IndexPath: UICollectionViewLayoutAttributes]]()
    private var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()

    private var sectionHeaderHeight : CGFloat = 45
    
    private let cellPadding: CGFloat = 6
    private var collectionViewHeight: CGFloat {
        return collectionView!.frame.height
    }

    private var collectionViewWidth: CGFloat {
        return collectionView!.frame.width
    }

    private var contentOffset: CGPoint {
        return collectionView!.contentOffset
    }
    var stickyOffset: CGFloat = 0
}

// MARK: - LAYOUT CORE PROCESS
extension CustomLayout {

    override public func prepare() {
        guard cache.isEmpty == true || cache.isEmpty == false, let collectionView = collectionView else {
            return
        }

        prepareCache()
        contentHeight = 0
        oldBounds = collectionView.bounds

        let sections = collectionView.numberOfSections
     
        var masterY : [CGFloat] = [0]
        
        
        for section in 0..<sections {
            let itemCount = collectionView.numberOfItems(inSection: section)
            if(itemCount == 0){
                masterY.append(masterY[section] )
                continue
            }
            
            let layoutDelegate = collectionView.delegate as? UICollectionViewDelegateLayoutAttribute

        
            
            if let flowDelegateLayout = collectionView.delegate as? UICollectionViewDelegateFlowLayout,
                let headerSize = flowDelegateLayout.collectionView?(collectionView, layout: self, referenceSizeForHeaderInSection: section) {
                let kind = UICollectionView.elementKindSectionHeader
                let indexPath = IndexPath(item: 0, section: section)
                let headerAttributes = layoutDelegate?.collectionView?(
                    collectionView,
                    kind: kind,
                    forSupplementary: indexPath
                ) ?? UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
                prepareHeaderFooterElement(size: headerSize, kind: UICollectionView.elementKindSectionHeader, attributes: headerAttributes)
            }
            
            let scrollDirection = delegate?.collectionView(collectionView, scrollDirectionOfSection: section)
            let numberOfColumns = delegate?.collectionView(collectionView , rowOfSection : section) ?? 0
            
          
            
            if(scrollDirection == .vertical){
                let columnWidth = collectionViewWidth / CGFloat(numberOfColumns)
                var xOffset: [CGFloat] = []
                var column = 0
                for column in 0..<numberOfColumns {
                    xOffset.append(CGFloat(column) * columnWidth)
                }
                var yOffset: [CGFloat] = .init(repeating: masterY[section] + sectionHeaderHeight, count: numberOfColumns)
             
                for item in 0..<itemCount {
                    let indexPath = IndexPath(item: item, section: section)
                    let photoHeight = delegate?.collectionView( collectionView,
                                                                heightForPhotoAtIndexPath: indexPath , cellWidth: columnWidth) ?? 180
                    let height = cellPadding * 2 + photoHeight
                    let frame = CGRect(x: xOffset[column],y: yOffset[column] , width: columnWidth , height: height)
                    let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = insetFrame
                    contentHeight = max(contentHeight, frame.maxY)
                    cache[.cell]?.updateValue(attributes, forKey: indexPath)
                                    
                    yOffset[column] = yOffset[column] + height
                    column = column < (numberOfColumns - 1) ? (column + 1) : 0
                    
                    //마지막셀에서만
                    //컨텐츠를 다합한거의 제일 큰거부터 아이템이 다시 시작해야함
                    if(item == itemCount - 1){
                        var masterHeight : CGFloat = 0
                        for height in yOffset {
                            if(height > masterHeight){
                                masterHeight = height
                            }
                        }
                        masterY.append(masterHeight)
                    }
                }
            }else{
                let height : CGFloat = 45
                let frame = CGRect(x: 0 , y: masterY[section] + height , width: collectionViewWidth , height: height)
                let indexPath = IndexPath(item: 0, section: section)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache[.cell]?.updateValue(attributes, forKey: indexPath)
                masterY.append(masterY[section]  + height + sectionHeaderHeight)
            }
        }
    }

    
    private func prepareCache() {
        cache.removeAll(keepingCapacity: true)
        cache[.sectionHeader] = [IndexPath: UICollectionViewLayoutAttributes]()
        cache[.cell] = [IndexPath: UICollectionViewLayoutAttributes]()
    }
    
    private func prepareHeaderFooterElement(size: CGSize, kind: String, attributes: UICollectionViewLayoutAttributes) {
        guard size != .zero else { return }

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let alphaAttr = attributes 
//            alphaAttr.initialOrigin = CGPoint(x: 0, y: contentHeight)
            attributes.frame = CGRect(origin: CGPoint(x: 0, y: contentHeight), size: size)
            attributes.zIndex = 1
            contentHeight = attributes.frame.maxY
            cache[.sectionHeader]?[attributes.indexPath] = attributes
        default: break
        }
    }
    private func rowAttributeSetting(_ scrollDirection : UICollectionView.ScrollDirection , numberOfColumns : Int){
        
    }
    
    
}


extension CustomLayout {

    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if oldBounds.size != newBounds.size {
            cache.removeAll(keepingCapacity: true)
        }
        return true
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            return cache[.sectionHeader]?[indexPath]
       default:
            return nil
        }
    }
    
    
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[.cell]?[indexPath]
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
     
        visibleLayoutAttributes.removeAll(keepingCapacity: true)


        for (_, elementInfos) in cache {
            for (_, attributes) in elementInfos {
                attributes.transform = .identity

                //updateAttributes(collectionView: collectionView, attributes: attributes, indexPath: indexPath)
                if attributes.frame.intersects(rect) {
                    visibleLayoutAttributes.append(attributes)
                }
            }
        }
        return visibleLayoutAttributes
    }

    
    private func updateAttributes(collectionView: UICollectionView, attributes: UICollectionViewLayoutAttributes, indexPath: IndexPath) {
        let attributes = attributes
        attributes.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: sectionHeaderHeight)
        
    }
}
