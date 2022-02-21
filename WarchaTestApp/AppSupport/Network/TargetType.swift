
import Foundation
import Alamofire


//Moya 처럼 사용 가능하게 만들기위해
protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var headers : HTTPHeaders { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: RequestParams { get }
}


extension TargetType {

    // URLRequestConvertible 구현
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        urlRequest.headers = headers
        
        switch parameters {
        case .query(let request):
            let params = request?.toDictionary() ?? [:]
            let queryParams = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
        case .body(let request):
            let params = request?.toDictionary() ?? [:]
        
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        }
        
        return urlRequest
    }
}

//요청은 Json으로 만들기 때문에 Encodeable
enum RequestParams {
    case query(_ parameter: Encodable?)
    case body(_ parameter: Encodable?)
}


extension Encodable {
    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let jsonData = try? JSONSerialization.jsonObject(with: data),
              let dictionaryData = jsonData as? [String: Any] else { return [:] }
        return dictionaryData
    }
}
