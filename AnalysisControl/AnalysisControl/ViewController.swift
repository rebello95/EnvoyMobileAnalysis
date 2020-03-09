import UIKit

private let kRequestAuthority = "api.lyft.com"
private let kRequestPath = "/ping"
private let kRequestScheme = "https"

final class ViewController: UIViewController {
    private var requestCount = 0
    private var timer: Timer?
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        configuration.timeoutIntervalForRequest = 15
        return URLSession(configuration: configuration)
    }()

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

        let url = URL(string: "\(kRequestScheme)://\(kRequestAuthority)\(kRequestPath)")!
        print("Starting request to '\(url.path)'")

        self.session.dataTask(with: url) { _, response, error in
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                print("[\(requestNumber)] response (\(statusCode))")
            } else if let error = error {
                print("[\(requestNumber)] error: \(error)")
            }
        }.resume()
    }
}
