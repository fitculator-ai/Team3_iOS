//
//  APIEndpoints.swift
//  Core
//
//  Created by JIHYE SEOK on 2/18/25.
//

import Alamofire

public enum APIEndpoint {
    case getWeeklyWorkout(userId: Int, targetDate: String)
    case getWorkoutCount(userId: Int, targetDate: String)
    case getWorkoutIntensity(userId: Int, targetDate: String)
    case getWorkoutDetail(recordId: String)
    case updateWorkout(request: WorkoutUpdateRequest)
    case deleteWorkout(userId: Int, workoutId: String)
    case createWorkout(request: WorkoutRequest)
    case getExercises(exerciseType: String, userId: String)
    case getMyPage(userId: Int)
    case updateMyPage(request: MyPageRequest)
    case updateHeartRate(request: HeartRateRequest)
    case getMyPageProfileImage(userId: Int)
    case createMyPageProfileImage(userId: Int, filedata: String)
    
    public var baseURL: String {
        return NetworkConstants.baseURL
    }

    public var path: String {
        switch self {
        case .getWeeklyWorkout:
            return "/workout/week"
        case .getWorkoutCount:
            return "/workout/count"
        case .getWorkoutIntensity:
            return "/workout/intensity"
        case .getWorkoutDetail(let recordId):
            return "/workout/\(recordId)"
        case .updateWorkout, .deleteWorkout, .createWorkout:
            return "/workout"
        case .getExercises:
            return "/exercise"
        case .getMyPage, .updateMyPage:
            return "/mypage"
        case .updateHeartRate:
            return "/mypage/heartUpdate"
        case .getMyPageProfileImage, .createMyPageProfileImage:
            return "/img"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getWeeklyWorkout, .getWorkoutCount, .getWorkoutIntensity,
                .getWorkoutDetail, .getExercises, .getMyPage, .getMyPageProfileImage :
            return .get
        case .updateWorkout, .updateMyPage, .updateHeartRate:
            return .put
        case .deleteWorkout:
            return .delete
        case .createWorkout, .createMyPageProfileImage: // `.createMyPageProfileImage`는 `post` 메서드로 변경
            return .post
        }
    }
    
    public var parameters: Parameters? {
        switch self {
        case .getWeeklyWorkout(let userId, let targetDate),
             .getWorkoutCount(let userId, let targetDate),
             .getWorkoutIntensity(let userId, let targetDate):
            return ["userId": userId, "targetDate": targetDate]
        case .getWorkoutDetail:
            return nil
        case .updateWorkout(let request):
            return request.toDictionary()
        case .deleteWorkout(let userId, let workoutId):
            return ["userId": userId, "workoutId": workoutId]
        case .createWorkout(let request):
            return request.toDictionary()
        case .getExercises(let exerciseType, let userId):
            return ["exerciseType": exerciseType, "userId": userId]
        case .getMyPage(let userId):
            return ["userId": userId]
        case .updateMyPage(let request):
            return request.toDictionary()
        case .updateHeartRate(let request):
            return request.toDictionary()
        case .getMyPageProfileImage(userId: let userId):
            return ["userId": userId]
        case .createMyPageProfileImage(userId: let userId, let filedata): // `filedata`를 받아오는 부분
            return ["userId": userId, "filedata": filedata]
        }
    }
}
