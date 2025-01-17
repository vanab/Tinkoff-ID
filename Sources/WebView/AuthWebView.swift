//
//  AuthWebView.swift
//  TinkoffID
//
//  Copyright (c) 2023 Tinkoff
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation
import WebKit

protocol IAuthWebViewDelegate: AnyObject {
    func authWebView(_ webView: IAuthWebView, didOpen url: URL)
}

protocol IAuthWebView: AnyObject {
    var delegate: IAuthWebViewDelegate? { get set }

    func open(from: UIViewController?)
    func dismiss()
}

final class AuthWebView: UIViewController {
    
    weak var delegate: IAuthWebViewDelegate?

    private let webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .nonPersistent()
        return WKWebView(frame: .zero, configuration: configuration)
    }()
    private let options: AppLaunchOptions
    private var baseUrl: String
    private let pinningDelegate: WKNavigationDelegate
    
    init(pinningDelegate: PinningDelegate,
         options: AppLaunchOptions,
         baseUrl: String) {
        self.pinningDelegate = pinningDelegate
        self.options = options
        self.baseUrl = baseUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Закрыть",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(closeButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Bundle.resourcesBundle?.imageNamed("reload"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(reloadButtonClicked))
        
        view.addSubview(webView)
        webView.navigationDelegate = self
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.topAnchor, constant: navigationController?.navigationBar.frame.size.height ?? 44).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        loadWebView()
    }
    
    // MARK: - Private
    
    private func loadWebView() {
        do {
            let url = try buildWebViewURL(with: options)
            let request = URLRequest(url: url)
            DispatchQueue.main.async {
                self.webView.load(request)
            }
        } catch {
            fatalError("Invalid URL provided to WebView")
        }
    }
    
    private func buildWebViewURL(with options: AppLaunchOptions) throws -> URL {
        let params = [
            "client_id": options.clientId,
            "code_verifier": options.payload.verifier,
            "code_challenge_method": options.payload.challengeMethod,
            "code_challenge": options.payload.challenge,
            "redirect_uri": options.callbackUrl,
            "response_type": "code",
            "response_mode": "query"
        ]
        
        var components = URLComponents(string: "\(baseUrl)/auth/authorize")
        components?.queryItems = params.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        enum Error: Swift.Error {
            case unableToInitializeUrl
        }
        
        guard let url = components?.url else {
            throw Error.unableToInitializeUrl
        }
        
        return url
    }
    
    @objc private func closeButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc private func reloadButtonClicked() {
        loadWebView()
    }
}

// MARK: - IAuthWebView

extension AuthWebView: IAuthWebView {

    func open(from: UIViewController?) {
        let navigationController = UINavigationController(rootViewController: self)
        from?.present(navigationController, animated: true)
    }

    func dismiss() {
        dismiss(animated: true)
    }
}

// MARK: - WKNavigationDelegate

extension AuthWebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else { return }
        
        if url.absoluteString == "https://www.tinkoff.ru/" {
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
        delegate?.authWebView(self, didOpen: url)
    }
    
    public func webView(_ webView: WKWebView,
                        didReceive challenge: URLAuthenticationChallenge,
                        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        pinningDelegate.webView?(webView, didReceive: challenge, completionHandler: completionHandler)
    }
}
