//
//  APIEndpoints.swift
//  Core
//
//  Created by JIHYE SEOK on 2/18/25.
//

import Alamofire

public enum APIEndpoint {
    case getFirstWorkoutDate(userId: Int)
    case getWeeklyWorkout(userId: Int, targetDate: String)
    case getWorkoutCount(userId: Int, targetDate: String)
    case getWorkoutIntensity(userId: Int, targetDate: String)
    case getWorkoutDetail(recordId: String)
    case updateWorkout(request: WorkoutUpdateRequest)
    case deleteWorkout(userId: Int, recordId: Int)
    case createWorkout(request: WorkoutRequest)
    case getExercises(exerciseType: String, userId: String)
    case getMyPage(userId: Int)
    case updateMyPage(request: MyPageRequest)
    case updateHeartRate(request: HeartRateRequest)
    case addFavorite(request: FavoriteRequest)
    case removeFavorite(request: FavoriteRequest)
    
    public var baseURL: String {
        return NetworkConstants.baseURL
    }

    public var path: String {
        switch self {
        case .getFirstWorkoutDate:
            return "/workout/firstWorkout"
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
        case .addFavorite:
            return "/favorite"
        case .removeFavorite:
            return "/favorite"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getFirstWorkoutDate, .getWeeklyWorkout, .getWorkoutCount, .getWorkoutIntensity,
             .getWorkoutDetail, .getExercises, .getMyPage:
            return .get
        case .updateWorkout, .updateMyPage, .updateHeartRate:
            return .put
        case .deleteWorkout, .removeFavorite:
            return .delete
        case .createWorkout, .addFavorite:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getWeeklyWorkout(let userId, let targetDate),
             .getWorkoutCount(let userId, let targetDate),
             .getWorkoutIntensity(let userId, let targetDate):
            return ["userId": userId, "targetDate": targetDate]
        case .getWorkoutDetail:
            return nil
        case .updateWorkout(let request):
            return request.toDictionary()
        case .deleteWorkout(let userId, let recordId):
            return ["userId": userId, "workoutId": recordId]
        case .createWorkout(let request):
            return request.toDictionary()
        case .getExercises(let exerciseType, let userId):
            return ["exerciseType": exerciseType, "userId": userId]
        case .getFirstWorkoutDate(let userId),
                .getMyPage(let userId):
            return ["userId": userId]
        case .updateMyPage(let request):
            return request.toDictionary()
        case .updateHeartRate(let request):
            return request.toDictionary()
        case .addFavorite(let request), .removeFavorite(let request):
            return request.toDictionary()
        }
    }
}

