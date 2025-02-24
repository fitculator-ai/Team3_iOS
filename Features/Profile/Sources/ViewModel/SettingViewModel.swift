//
//  SettingViewModel.swift
//  Core
//
//  Created by Heeji Jung on 2/19/25.
//

import Foundation
import Core

class SettingViewModel: ObservableObject {
    
    @Published public var HeartRateRequest: HeartRateRequest?
    @Published var isValid: Bool = true
    
    public func validateHeartRate() -> Bool {
        let heartRate = HeartRateRequest?.userHeartRate ?? 40
        
        if heartRate >= 40 && heartRate <= 120 {
            isValid = true
            return true
        } else {
            isValid = false
            return false
        }
    }
    
   /* public func updateHeartRate(request: HeartRateRequest, completion: @escaping (Bool, Error?) -> Void) {
        // API 요청을 보낼 엔드포인트 선택
        let endpoint = APIEndpoint.updateHeartRate(request: request)

        // Alamofire로 HTTP 요청 보내기
        AF.request(endpoint.baseURL + endpoint.path, method: .put, parameters: endpoint.parameters, encoding: JSONEncoding.default)
            .response { response in
                // 응답 데이터 출력 (디버깅용)
                if let responseData = response.data, let responseString = String(data: responseData, encoding: .utf8) {
                    print("Server Response: \(responseString)") // 서버 응답을 확인
                }

                switch response.result {
                case .success:
                    if let statusCode = response.response?.statusCode, statusCode == 200 {
                        // 응답 데이터로 HeartRateResponse 객체를 파싱
                        if let data = response.data {
                            do {
                                // 응답 데이터를 HeartRateResponse로 파싱
                                let response = try JSONDecoder().decode(validateHeartRate.self, from: data)

                                // 성공적인 응답인지 확인
                                if response.success {
                                    print("Response Message: \(response.message)") // 성공 메시지
                                    
                                    // 옵셔널 언래핑을 통해 HeartRateRequest의 값을 갱신
                                    if let heartRateRequest = self.HeartRateRequest {
                                        heartRateRequest.userHeartRate = request.userHeartRate
                                    }

                                    // 갱신된 값을 클라이언트에서 유지
                                    completion(true, nil)
                                } else {
                                    completion(false, NSError(domain: "Error", code: 400, userInfo: [NSLocalizedDescriptionKey: response.message]))
                                }
                            } catch {
                                print("Parsing error: \(error.localizedDescription)") // Parsing 오류 출력
                                completion(false, NSError(domain: "Parsing Error", code: 500, userInfo: nil))
                            }
                        }
                    } else {
                        completion(false, NSError(domain: "Server Error", code: 500, userInfo: nil))
                    }
                case .failure(let error):
                    completion(false, error)  // 실패
                }
            }
    }*/

}
