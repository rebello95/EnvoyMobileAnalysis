import Envoy
import UIKit

private let kRequestAuthority = "api.lyft.com"
private let kRequestPath = "/ping"
private let kRequestScheme = "https"

final class ViewController: UIViewController {
    private var requestCount = 0
    private var timer: Timer?
    private let envoy = try! EnvoyClientBuilder()
        .addConnectTimeoutSeconds(15)
        .build()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.startRequests()
    }

    deinit {
        self.timer?.invalidate()
    }

    // MARK: - Requests

    private func startRequests() {
        self.timer = .scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            DispatchQueue.global().async {
                self?.performRequest()
            }
        }
    }

    private func performRequest() {
        self.requestCount += 1
        let requestNumber = self.requestCount

        let request = RequestBuilder(
            method: .get, scheme: kRequestScheme, authority: kRequestAuthority, path: kRequestPath).build()
        let handler = ResponseHandler()
            .onHeaders { _, statusCode, _ in
                print("[\(requestNumber)] response (\(statusCode))")
            }
            .onError { error in
                print("[\(requestNumber)] error: \(error)")
            }

        print("Starting request to '\(kRequestPath)'")
        self.envoy.send(request, body: nil, handler: handler)
    }
}
