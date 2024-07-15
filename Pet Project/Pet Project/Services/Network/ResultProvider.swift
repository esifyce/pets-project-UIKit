//
//  ResultProvider.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import RxSwift
import Moya

class ResultProvider<Target: TargetType>: MoyaProvider<Target> {
    
    init(
        endpointClosure: @escaping ResultProvider<Target>.EndpointClosure = ResultProvider.defaultEndpointMapping,
        requestClosure: @escaping ResultProvider<Target>.RequestClosure = ResultProvider.defaultRequestMapping,
        stubClosure: @escaping ResultProvider<Target>.StubClosure = ResultProvider.neverStub,
        callbackQueue: DispatchQueue? = nil,
        session: Session = ResultProvider<Target>.defaultAlamofireSession(),
        tokenPlugin: TokenPlugin,
        plugins: [PluginType] = [],
        trackInflights: Bool = false
    ) {
        super.init(
            endpointClosure: endpointClosure,
            requestClosure: requestClosure,
            stubClosure: stubClosure,
            callbackQueue: callbackQueue,
            session: session,
            plugins: plugins + [tokenPlugin],
            trackInflights: trackInflights
        )
    }
    
    func request<SuccessModel: Codable>(
        _ target: Target,
        successModel: SuccessModel.Type = SuccessModel.self,
        callbackQueue: DispatchQueue? = nil
    ) -> Single<SuccessModel> {
        rx.request(target).filterSuccessfulStatusCodes()
            .withLogging()
            .map { [unowned self] in try parse(objectType: successModel, data: $0.data) }
            
    }
    
    private func parse<T: Codable>(objectType: T.Type, data: Data) throws -> T {
        return try JSONDecoder().decode(objectType, from: data)
    }
}

private extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func withLogging() -> PrimitiveSequence<Trait, Element> {
        self.do(
            onSuccess: { response in
                print(String(repeating: "\n", count: 2))
                debugPrint(response.statusCode, response.request?.url?.path ?? "")
                debugPrint(String(repeating: "-", count: 30))
                debugPrint("👀 LOG:")
                debugPrint(response.statusCode, response.data.prettyPrintedJSONString)
                debugPrint(String(repeating: "-", count: 30))
                print(String(repeating: "\n", count: 2))
            },
            onError: { error in
                print(String(repeating: "\n", count: 2))
                debugPrint(String(repeating: "-", count: 30))
                debugPrint("🐞 ERROR:")
                debugPrint(error.localizedDescription)
                debugPrint(String(repeating: "-", count: 30))
                print(String(repeating: "\n", count: 2))
            }
        )
    }
}

private extension Data {
    var prettyPrintedJSONString: NSString {
        guard
            let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        else { return "🐞 Couldn't parse data" }
        return prettyPrintedString
    }
}
