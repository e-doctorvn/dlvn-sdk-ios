
import Foundation
import Apollo

class Network {
    static let shared = Network()
    private(set) lazy var apollo: ApolloClient = {
        let client = URLSessionClient()
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let provider = NetworkInterceptorProvider(client: client, store: store)
        let url = URL(string: "https://virtual-clinic.api.e-doctor.dev/graphql")!
        let transport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: url)

        let webSocket = WebSocket(
            url: URL(string: "wss://virtual-clinic.api.e-doctor.dev/graphql")!,
            protocol: .graphql_ws
        )
        let authPayload: JSONEncodableDictionary = ["authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImN0eSI6ImVkb2N0b3ItYXBpO3Y9MSJ9.eyJqdGkiOiJjb25zdW1lcjo2NjAzMWZiNGRlYTFiMzAwMTNhYzc1NDEiLCJleHAiOjIwMjY4NDA3NjQsInVzZXJUeXBlIjoiY29uc3VtZXIiLCJ1c2VySWQiOiI2NjAzMWZiNGRlYTFiMzAwMTNhYzc1NDEiLCJpYXQiOjE3MTE0ODA3NjR9.GBUJM03ZWIkZmGRFWrq0GQhEIGpHdjPAPfRWEdsbdTU"]

        let webSocketTransport = WebSocketTransport(websocket: webSocket, config: WebSocketTransport.Configuration(connectingPayload: authPayload))

        let splitTransport = SplitNetworkTransport(
            uploadingNetworkTransport: transport,
            webSocketNetworkTransport: webSocketTransport
        )

        return ApolloClient(networkTransport: splitTransport, store: store)
    }()
}
