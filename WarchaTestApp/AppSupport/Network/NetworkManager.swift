
import Foundation
import Combine
import Alamofire


// 1. Error 타입 정의
enum APIError: Error {
    case http(ErrorData)
   
    case unknown
    
}

// 2. ErrorData 안에 들어갈 정보 선언
struct ErrorData: Codable {
    var statusCode: Int
    var message: String
    var error: String?
}

protocol ApiProtocol {
    
    func request<T: Decodable>(_ targetType : TargetType) -> AnyPublisher<T, APIError>
    func run<T: Decodable>(_ request: DataRequest, _ decoder: JSONDecoder ) -> AnyPublisher<Response<T>, APIError>
}


struct Response<T> {
    let value: T
    let response: URLResponse
}

class ApiManager : ApiProtocol {
    
    static let shared = ApiManager()
    
    // 4. Resonse 선언
    
      
    
    
    func request<T: Decodable>(_ targetType : TargetType) -> AnyPublisher<T, APIError> {
        
        let dataRequest = try! AF.request(targetType.asURLRequest())
        
       
        return run(dataRequest)
            .map(\.value)
            .eraseToAnyPublisher()
        
    }
    
    
    
    
    func run<T: Decodable>(_ request: DataRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, APIError> {
        
        
        
        
        request.validate().publishData(emptyResponseCodes : [200 , 204 , 205]).tryMap { result -> Response<T> in
          
            if let error = result.error {
                throw error
            }
            if let data = result.data {
                 let value = try decoder.decode(T.self, from: data)
                return Response(value: value, response: result.response!)
            } else {
                // 응답이 성공이고 result가 없을 때 Empty를 리턴
                return Response(value: Empty.emptyValue() as! T , response: result.response!)
            }
        }
        .mapError({ (error) -> APIError in
            print("디코딩오류")
            return .unknown
        })
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
   
}
