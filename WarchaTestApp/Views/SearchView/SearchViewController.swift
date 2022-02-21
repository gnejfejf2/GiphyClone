//
//  ViewController.swift
//  WarchaTestApp
//
//  Created by Hwik on 2022/02/19.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    
    
    private let searchTextField : UITextField =   {
        let view = TextFieldWithPadding()
        view.placeholder = "Search GIPHY"
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    
    
    private let searchIcon : UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        view.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let selectTabBarView : UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let gifsButton : UIButton = {
        let view = UIButton()
        view.setTitle("GIFs", for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stickersButton : UIButton = {
        let view = UIButton()
        view.setTitle("Stickers", for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let textButton : UIButton = {
        let view = UIButton()
        view.setTitle("Text", for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let chipView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var chipViewLeadingAncher : NSLayoutConstraint?
    
    
    
    lazy var mainTableView: UICollectionView = {
        let  collectionViewLayout : CustomLayout = CustomLayout()
        collectionViewLayout.delegate = self
        //        collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        //        collectionViewLayout.minimumInteritemSpacing = 10
        //        collectionViewLayout.minimumLineSpacing = 10
        //        collectionViewLayout.collectionViewLayout = commentFlowLayout
        //        collectionViewLayout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        //          layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width - 20*2, height: 200)
        collectionView.backgroundColor = .black
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.id)
        collectionView.register(RecentCollectionViewCell.self, forCellWithReuseIdentifier: RecentCollectionViewCell.id)
        collectionView.register(TrendingCollectionViewCell.self, forCellWithReuseIdentifier: TrendingCollectionViewCell.id)
        collectionView.register(GifCollectionViewCell.self, forCellWithReuseIdentifier: GifCollectionViewCell.id)
        return collectionView
    }()
    
   
    var viewModel : SearchViewModel? 
    
    var bindings = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetting()
        uiDrawing()
        ViewModelBinding()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.uiSetting()
            self?.viewModel?.searchAction(keyword: "Korea")
        }
        
    }
    
    func ViewModelBinding() {
        
        viewModel?.$collectionItem
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] item in
                self?.mainTableView.reloadData()
            })
            .store(in: &bindings)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.mainTableView.reloadData()
        }
    }
    
    
    private func navigationBarSetting(){
        view.backgroundColor = .black
        navigationItem.title = "Search"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.barTintColor = .black
    }
    
    private func uiDrawing(){
        view.addSubview(searchTextField)
        view.addSubview(searchIcon)
        view.addSubview(selectTabBarView)
        selectTabBarView.addSubview(chipView)
        selectTabBarView.addSubview(gifsButton)
        selectTabBarView.addSubview(stickersButton)
        selectTabBarView.addSubview(textButton)
        view.addSubview(mainTableView)
        
        
        searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: searchIcon.leadingAnchor).isActive = true
        searchTextField.heightAnchor.constraint(equalTo: searchIcon.heightAnchor).isActive = true
        searchIcon.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        searchIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchIcon.widthAnchor.constraint(equalTo: searchIcon.heightAnchor).isActive = true
        searchIcon.sizeToFit()
        selectTabBarView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor).isActive = true
        selectTabBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        selectTabBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        selectTabBarView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        chipView.topAnchor.constraint(equalTo: selectTabBarView.topAnchor).isActive = true
        chipView.bottomAnchor.constraint(equalTo: selectTabBarView.bottomAnchor).isActive = true
        chipView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 3).isActive = true
        chipViewLeadingAncher = chipView.leadingAnchor.constraint(equalTo: selectTabBarView.leadingAnchor)
        chipViewLeadingAncher?.isActive = true
        
        gifsButton.topAnchor.constraint(equalTo: selectTabBarView.topAnchor).isActive = true
        gifsButton.bottomAnchor.constraint(equalTo: selectTabBarView.bottomAnchor).isActive = true
        gifsButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 3).isActive = true
        gifsButton.leadingAnchor.constraint(equalTo: selectTabBarView.leadingAnchor).isActive = true
        gifsButton.trailingAnchor.constraint(equalTo: stickersButton.leadingAnchor).isActive = true
        stickersButton.topAnchor.constraint(equalTo: selectTabBarView.topAnchor).isActive = true
        stickersButton.bottomAnchor.constraint(equalTo: selectTabBarView.bottomAnchor).isActive = true
        stickersButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 3).isActive = true
        stickersButton.trailingAnchor.constraint(equalTo: textButton.leadingAnchor).isActive = true
        textButton.topAnchor.constraint(equalTo: selectTabBarView.topAnchor).isActive = true
        textButton.bottomAnchor.constraint(equalTo: selectTabBarView.bottomAnchor).isActive = true
        textButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 3).isActive = true
        
        mainTableView.topAnchor.constraint(equalTo: selectTabBarView.bottomAnchor).isActive = true
        mainTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mainTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        mainTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        
    }
    
    private func uiSetting(){
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        chipView.makeChipsGradient(colors : [UIColor.systemPink.cgColor , UIColor(named: "pink2")!.cgColor ])
        
        searchIcon.applyGradient(colors : [UIColor.systemPink.cgColor , UIColor(named: "pink2")!.cgColor ])
        
    }
    
    
}

extension SearchViewController  : UICollectionViewDataSource, UICollectionViewDelegate , PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, scrollDirectionOfSection section: Int) -> UICollectionView.ScrollDirection {
        if(viewModel?.collectionItem[section].SectionName == .trending){
            return .vertical
        }else if (viewModel?.collectionItem[section].SectionName == .recent){
            return .vertical
        }else{
            return .vertical
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        
        if(viewModel?.collectionItem[indexPath.section].SectionName == .trending){
            return 45
        }else if (viewModel?.collectionItem[indexPath.section].SectionName == .recent){
            
            return 45
        }else{
            guard let imageItem = (viewModel?.collectionItem[indexPath.section].Items[indexPath.item] as! Gif).images?.original else { return 0 }
            let height =  imageItem.height.getCGFloat() * UIScreen.main.bounds.width / 2 / imageItem.width.getCGFloat()
            return height
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 45)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, rowOfSection section: Int) -> Int {
        if(viewModel?.collectionItem[section].SectionName == .trending){
            return 1
        }else if (viewModel?.collectionItem[section].SectionName == .recent){
            return 1
        }else{
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.collectionItem[section].Items.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.id, for: indexPath) as! HeaderCollectionReusableView
        
        headerview.label.text = viewModel?.collectionItem[indexPath.section].SectionName.rawValue
        headerview.backgroundColor = .black
        return headerview
        
    }
    
}

extension SearchViewController: UICollectionViewDelegateFlowLayout , UICollectionViewDelegateLayoutAttribute {
    func collectionView(_ collectionView: UICollectionView, kind: String, forSupplementary indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        HeaderAttribute(forSupplementaryViewOfKind: kind, with: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, forItemAt indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        nil
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(viewModel?.collectionItem[indexPath.section].SectionName == .trending){
            let cell : TrendingCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingCollectionViewCell.id, for: indexPath) as! TrendingCollectionViewCell
            cell.label.text =  viewModel?.collectionItem[indexPath.section].Items[indexPath.row] as? String
            cell.label.textColor = .white
            return cell
        }else if (viewModel?.collectionItem[indexPath.section].SectionName == .recent){
            let cell : RecentCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentCollectionViewCell.id, for: indexPath) as! RecentCollectionViewCell
            cell.label.text =  viewModel?.collectionItem[indexPath.section].Items[indexPath.row] as? String
            return cell
        }else{
            let cell : GifCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: GifCollectionViewCell.id, for: indexPath) as! GifCollectionViewCell
            let item : Gif = viewModel?.collectionItem[indexPath.section].Items[indexPath.row] as! Gif
            cell.item = item
            cell.uiSetting()
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.collectionItem.count ?? 0
    }
    
    
}



class PinterestLayout: UICollectionViewLayout {
    
    weak var delegate: PinterestLayoutDelegate?
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty == true,let collectionView = collectionView else {
            return
        }
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let photoHeight = delegate?.collectionView( collectionView,
                                                        heightForPhotoAtIndexPath: indexPath , cellWidth: columnWidth) ?? 180
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column],y: yOffset[column],width: columnWidth,height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
            
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    
}
