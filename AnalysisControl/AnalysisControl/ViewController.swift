import UIKit

private let kRequestAuthority = "api.lyft.com"
private let kRequestPath = "/ping"
private let kRequestScheme = "https"

final class ViewController: UIViewController {
    private var requestCount = 0
    private var timer: Timer?

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
        self.timer = .scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.performRequest()
        }
    }

    private func performRequest() {
        self.requestCount += 1
        let requestNumber = self.requestCount

        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        configuration.timeoutIntervalForRequest = 15
        let session = URLSession(configuration: configuration)

        let url = URL(string: "\(kRequestScheme)://\(kRequestAuthority)\(kRequestPath)")!
        print("Starting request to '\(url.path)'")

        session.dataTask(with: url) { data, response, error in
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                print("[\(requestNumber)] response (\(statusCode)) with \(data?.count ?? 0) bytes")
            } else if let error = error {
                print("[\(requestNumber)] error: \(error)")
            }
        }.resume()
    }
}
