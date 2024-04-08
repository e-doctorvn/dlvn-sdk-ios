import Foundation
import Apollo
import API

class AuthorizationInterceptor: ApolloInterceptor {
    public var id: String = UUID().uuidString
    
    func interceptAsync<Operation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) where Operation : GraphQLOperation {
        request.addHeader(name: "Authorization", value: "Bearer: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyVHlwZSI6ImNvbnN1bWVyIiwic291cmNlVHlwZSI6IkRMVk4iLCJhY2NvdW50SWQiOiJkZXZfdHluY1R1aU9LbDVrUEpseSIsInVzZXJJZCI6IjY1NDg2ZGUyYzllMTY4MDAxMzgxZDlmZSIsImRjSWQiOiIwNTVGRDAzQy03NTI4LTRFRkYtQjI5Qi0wMTJGMDU0QkUzRDEiLCJkZXZpY2VpZCI6ImMyNjY2ZGU2OWU5ZDRlNzA5NmYyNTQ0NTM0ZmE4OTk4IiwiZGNBY2Nlc3NUb2tlbiI6IjAzY2Y3NjE4YmQ1YzQwM2Q4MjQ4NTIzMDg5NmI4OThiIiwiaWF0IjoxNzExOTYwNDE1fQ._l3X82W3bbcZgcnpKL_FTBZyYcczEG9_rMBvmnAIcr8")
        print(request.additionalHeaders)

        chain.proceedAsync(
            request: request,
            response: response,
            interceptor: self,
            completion: completion)
    }
    
}
