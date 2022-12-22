//
//  DetailViewController.swift
//  GitRepos
//
//  Created by Max on 11/04/22.
//

import UIKit
import WebKit

protocol DetailViewInputs: AnyObject {
    func configure(entities: DetailEntities?)
    func requestWebView(with request: URLRequest)
    func indicatorView(animate: Bool)
}

final class DetailViewController: UIViewController {

    internal var viewModel: DetailsViewModel?

    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let urlStr = viewModel?.entities.entryEntity.gitHubRepository.url , let url = URL(string: urlStr) {
            requestWebView(with: URLRequest(url:url))
            indicatorView(animate: true)
            configure(entities: viewModel?.entities)
        }
      
    }
}


extension DetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicatorView(animate: false)
    }
}

extension DetailViewController: DetailViewInputs {

    func configure(entities: DetailEntities?) {
        navigationItem.title = viewModel?.entities.entryEntity.gitHubRepository.fullName ?? ""
    }

    func requestWebView(with request: URLRequest) {
        webView.load(request)
    }

    func indicatorView(animate: Bool) {
        DispatchQueue.main.async { [weak self] in
            _ = animate ? self?.indicatorView.startAnimating() : self?.indicatorView.stopAnimating()
        }
    }

}

extension DetailViewController: Viewable {}
