
import Alamofire
import UIKit

typealias PathOption = [String : Any]

struct SearchQuery : Codable{
    var api_key : String = "rbT0E5nDwIV2Q4854RgCWsgUuaoQkahs"
    ///검색 키워드
    var q : String
    ///아이템 최대갯수
    var limit : Int
    ///현재 스크롤 아이템의 위치
    var offset : Int
    ///
    var rating : String = "g"
    
    var lang : String = "ko"
}


enum GIPTYAPI {
    
    case GIFS_SEARCH(SearchQuery)
    
    case STICKERS_SEARCH(SearchQuery)
    
    case TEXT_SEARCH(SearchQuery)
    
}


extension GIPTYAPI : TargetType{
    
    
    
    
    var baseURL: String {
        return  "https://api.giphy.com"
    }
    
    var headers : HTTPHeaders {
        return ["contentType" : "application/json;charset=utf-8"]
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .GIFS_SEARCH :
            return "/v1/gifs/search"
        case .STICKERS_SEARCH :
            return "/v1/stickers/search"
        case .TEXT_SEARCH :
            return "/v1/text/search"
        }
        
        
        
    }
    
    var parameters: RequestParams {
        switch self{
        case .GIFS_SEARCH(let request): return .query(request)
        case .STICKERS_SEARCH(let request): return .query(request)
        case .TEXT_SEARCH(let request): return .query(request)
        }
    }
    
    
    
    
}
