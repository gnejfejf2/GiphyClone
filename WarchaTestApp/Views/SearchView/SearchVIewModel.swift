//
//  SearchVIewModel.swift
//  WarchaTestApp
//
//  Created by Hwik on 2022/02/21.
//

import Foundation
import Combine

protocol SearchViewProtocol {
    var networkAPI : ApiManager { get }
    var coordinator : SearchCoordinator? { get set }
    var disposeBag : Set<AnyCancellable> { get set }
    var searchAction : PassthroughSubject<String, Never> { get set }
    var collectionItem  : [SectiionTableModel]  { get set }
    
    
    mutating func searchAction(keyword : String)
    func getCheckNonpayMent(keyWord  : String)  -> AnyPublisher<GifsModel , APIError>
}

class SearchViewModel : SearchViewProtocol {
    
    let networkAPI : ApiManager = ApiManager.shared
    
    var coordinator : SearchCoordinator?
    var disposeBag = Set<AnyCancellable>()
    
    var searchAction = PassthroughSubject<String, Never>()
    
    @Published var collectionItem  : [SectiionTableModel] = []
    
    
    init(){
        collectionItem.append(SectiionTableModel(SectionName: .trending, Items: ["Sunday Funday","JaysonTatum","Oil","Feast","Good Afternoon"]))
        collectionItem.append(SectiionTableModel(SectionName: .recent, Items: []))
        collectionItem.append(SectiionTableModel(SectionName: .most, Items: []))
      
      
        binding()
    }
    
    func binding(){
        searchAction
            .sink(receiveValue: { [weak self] keyword in
                self?.searchAction(keyword: keyword)
            })
            .store(in: &disposeBag)
    }
    
    
    
    func searchAction(keyword : String){
      
        self.getCheckNonpayMent(keyWord: keyword)
            .sink{ error in
                print(error)
            } receiveValue: { result in
                print(result)
                
                self.collectionItem[2].Items = result.data ?? []
            }.store(in: &disposeBag)
    }
    
    
}

extension SearchViewProtocol{
   
    func getCheckNonpayMent(keyWord  : String)  -> AnyPublisher<GifsModel , APIError> {
    
        networkAPI.request(GIPTYAPI.GIFS_SEARCH(SearchQuery(q: keyWord, limit: 25, offset: 0)))
    }
}
