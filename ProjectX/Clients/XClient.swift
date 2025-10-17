//
//  XClient.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/23/25.
//

import Alamofire
import Foundation

class XClient {
    static func get(_ firm: Firm) -> XClient {
        switch firm {
        case .alphaFutures:
            return self.alphaFutures
        case .aquaFutures:
            return self.aquaFutures
        case .fundingFutures:
            return self.fundingFutures
        case .holaPrime:
            return self.holaPrime
        case .lucidTrading:
            return self.lucidTrading
        case .topstep:
            return self.topstep
        case .tradeify:
            return self.tradeify
        }
    }
    
    static let alphaFutures = XClient(.alphaFutures)
    static let aquaFutures = XClient(.aquaFutures)
    static let fundingFutures = XClient(.fundingFutures)
    static let holaPrime = XClient(.holaPrime)
    static let lucidTrading = XClient(.lucidTrading)
    static let topstep = XClient(.topstep)
    static let tradeify = XClient(.tradeify)
    
    // Firm
    var firm: Firm
    
    // URLs
    let gatewayUrl: String
    let userUrl: String
    let userHubUrl: String
    let marketHubUrl: String
    
    init(_ firm: Firm) {
        self.firm = firm
        switch firm {
        case .alphaFutures:
            self.gatewayUrl = "https://api.alphaticks.projectx.com"
            self.userUrl = "https://userapi.alphaticks.projectx.com"
            self.userHubUrl = "https://rtc.alphaticks.projectx.com/hubs/user"
            self.marketHubUrl = "https://rtc.alphaticks.projectx.com/hubs/market"
        case .aquaFutures:
            self.gatewayUrl = "https://api.aquafutures.projectx.com"
            self.userUrl = "https://userapi.aquafutures.projectx.com"
            self.userHubUrl = "https://rtc.aquafutures.projectx.com/hubs/user"
            self.marketHubUrl = "https://rtc.aquafutures.projectx.com/hubs/market"
        case .fundingFutures:
            self.gatewayUrl = "https://api.fundingfutures.projectx.com"
            self.userUrl = "https://userapi.fundingfutures.projectx.com"
            self.userHubUrl = "https://rtc.fundingfutures.projectx.com/hubs/user"
            self.marketHubUrl = "https://rtc.fundingfutures.projectx.com/hubs/market"
        case .holaPrime:
            self.gatewayUrl = "https://api.holaprime.projectx.com"
            self.userUrl = "https://userapi.holaprime.projectx.com"
            self.userHubUrl = "https://rtc.holaprime.projectx.com/hubs/user"
            self.marketHubUrl = "https://rtc.holaprime.projectx.com/hubs/market"
        case .lucidTrading:
            self.gatewayUrl = "https://api.lucidtrading.projectx.com"
            self.userUrl = "https://userapi.lucidtrading.projectx.com"
            self.userHubUrl = "https://rtc.lucidtrading.projectx.com/hubs/user"
            self.marketHubUrl = "https://rtc.lucidtrading.projectx.com/hubs/market"
        case .topstep:
            self.gatewayUrl = "https://api.topstepx.com"
            self.userUrl = "https://userapi.topstepx.com"
            self.userHubUrl = "https://rtc.topstepx.com/hubs/user"
            self.marketHubUrl = "https://rtc.topstepx.com/hubs/market"
        case .tradeify:
            self.gatewayUrl = "https://api.tradeify.projectx.com"
            self.userUrl = "https://userapi.tradeify.projectx.com"
            self.userHubUrl = "https://rtc.tradeify.projectx.com/hubs/user"
            self.marketHubUrl = "https://rtc.tradeify.projectx.com/hubs/market"
        }
    }
    
    // Tokens
    var gatewayToken: String?
    var userToken: String?
    
    var authUserHubUrl: String {
        "\(userHubUrl)?access_token=\(gatewayToken!)"
    }
    
    var authMarketHubUrl: String {
        "\(userHubUrl)?access_token=\(gatewayToken!)"
    }
    
    func signIn(_ username: String, _ key: String) async -> Bool {
        gatewayToken = await signInGateway(username, key)
        userToken = await signInUser(username, key)
        return gatewayToken != nil && userToken != nil
    }
    
    func signInGateway(_ username: String, _ key: String) async -> String? {
        do {
            let params: [String: String] = [
                "userName": username,
                "apiKey": key
            ]
            let value = try await AF.request("\(gatewayUrl)/api/Auth/loginKey", method: .post, parameters: params, encoding: JSONEncoding.default).serializingDecodable(GatewayTokenDTO.self).value
            return value.token
        } catch {
            Helpers.debugLog("signInGateway: \(error)")
            return nil
        }
    }
    
    func signInUser(_ username: String, _ key: String) async -> String? {
        do {
            let params: [String: String] = [
                "userName": username,
                "apiKey": key
            ]
            let value = try await AF.request("\(userUrl)/Login/key", method: .post, parameters: params, encoding: JSONEncoding.default).serializingDecodable(UserTokenDTO.self).value
            return value.token
        } catch {
            Helpers.debugLog("signInUser: \(error)")
            return nil
        }
    }
    
    func signOut() async -> Bool {
        gatewayToken = nil
        userToken = nil
        return true
    }
    
    func getContracts() async -> [ContractDTO] {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(userToken!)"
        ]
        do {
            let value = try await AF.request("\(userUrl)/UserContract/active/nonprofesional", method: .get, headers: headers).serializingDecodable([ContractDTO].self).value
            return value
        } catch {
            Helpers.debugLog("getAccounts: \(error)")
            return []
        }
    }
    
    func getAccounts() async -> [AccountDTO] {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(userToken!)"
        ]
        do {
            let value = try await AF.request("\(userUrl)/TradingAccount", method: .get, headers: headers).serializingDecodable([AccountDTO].self).value
            return value
        } catch {
            Helpers.debugLog("getAccounts: \(error)")
            return []
        }
    }
    
    func getDailyStats(_ id: Int) async -> [DailyStatsDTO] {
        do {
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(userToken!)"
            ]
            let params: [String: Int] = [
                "tradingAccountId": id
            ]
            let value = try await AF.request("\(userUrl)/Statistics/lifetimestats", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).serializingDecodable([DailyStatsDTO].self).value
            return value
        } catch {
            Helpers.debugLog("getDailyStats: \(error)")
            return []
        }
    }
    
    func getTrades(_ id: Int) async -> [TradeDTO] {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(userToken!)"
        ]
        do {
            let value = try await AF.request("\(userUrl)/Trade/id/\(id)", method: .get, headers: headers).serializingDecodable([TradeDTO].self).value
            return value
        } catch {
            Helpers.debugLog("getTrades: \(error)")
            return []
        }
    }
}
