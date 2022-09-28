//
//  ViewModel.swift
//  CombineAPI
//
//  Created by Hung, Pham Van on 27/09/2022.
//

import Foundation
import Combine

class ViewModel {
    var disposables = Set<AnyCancellable>()
    
    func getExampleAsync() async throws -> ExampleModel {
        let router = ExampleEndPoint.getExample()
        let model = try await APIRequest.requestAsyncVer2(router, responseModel: ExampleModel.self)
        return model
    }
    
    func getMultiApisCombines() {
        let router = ExampleEndPoint.getExample()
        let first = APIRequest.requestCombineVer2(router, type: ExampleModel.self)
        let second = APIRequest.requestCombineVer2(router, type: ExampleModel.self)
        let both = Publishers.Zip(first, second)
        //let both = Publishers.CombineLatest(first, second)
        both.sink { first, second in
            switch first {
            case .success(let success):
                PHLogger.log("==== success")
            case .failure(let failure):
                PHLogger.log(failure.localizedDescription)
            }
            switch second {
            case .success(let success):
                PHLogger.log("==== success")
            case .failure(let failure):
                PHLogger.log(failure.localizedDescription)
            }
        }.store(in: &disposables)
        
    }
}
