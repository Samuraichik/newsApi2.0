//
//  APIErrors.swift
//  Networker
//
//  Created by Oleksiy Humenyuk on 22.12.2022.
//

import Foundation

public struct ApiCustomErrors: AnyModel, LocalizedError {
    public let failures: [ApiCustomError]
    public let internalErrorCode: InternalErrorCode?
}

public struct ApiCustomError: AnyModel {
    public let error: [String]
}

public enum InternalErrorCode: Int, AnyModel, LocalizedError {
    case invalidUserNamePass = 2000199
    case verificationCodeFailure = 1000021
    case noAvailableSlots = 1000053
    case requestFailed
    case userProfileFaiulure = 1000066
    
    public var businessErrorDescription: String {
        switch self {
        case .invalidUserNamePass: return "Invalid URL"
        case .requestFailed: return "Request failed"
        case .verificationCodeFailure: return "Verification code failure"
        case .noAvailableSlots: return "No available slots"
        case .userProfileFaiulure: return "Email already exist"
        }
    }
}

