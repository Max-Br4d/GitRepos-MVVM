//
//  ListViewController.swift
//  GitRepos
//
//  Created by Max on 11/04/22.
//

import UIKit

import UIKit

protocol ListViewInputs: AnyObject {
    func configure(entities: ListEntities?)
    func reloadTableView()
    func indicatorView(animate: Bool)
}

final class ListViewController: UIViewController {

    internal var viewModel: RepoListViewModel?
    internal var router: ListRouterOutput?
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(entities: viewModel?.entities)
        let request = SearchLanguageRequest(language:"Swift", page:1)

        viewModel?.fetchSearch(request: request)
    }

}

extension ListViewController: ListViewInputs {

    func configure(entities: ListEntities?) {
        navigationItem.title = "\(entities?.entryEntity.language ?? "") Repositories"
    }

    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView?.reloadData()
        }
    }

    func indicatorView(animate: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: animate ? 50 : 0, right: 0)
            _ = animate ? self?.indicatorView?.startAnimating() : self?.indicatorView?.stopAnimating()
        }
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.entities.gitHubRepositories.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let repo = viewModel?.entities.gitHubRepositories[safe: indexPath.row] else { return UITableViewCell() }
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "subtitle")
        cell.textLabel?.text = "\(repo.fullName)"
        cell.detailTextLabel?.textColor = UIColor.lightGray
        cell.detailTextLabel?.text = "\(repo.description)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedRepo = viewModel?.entities.gitHubRepositories[safe: indexPath.row] else { return }
        router?.transitionDetail(gitHubRepository: selectedRepo)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleLastIndexPath = tableView.visibleCells.compactMap { [weak self] in
            self?.tableView.indexPath(for: $0)
        }.last
        guard let last = visibleLastIndexPath, last.row > (viewModel?.entities.gitHubRepositories.count ?? 0) - 2 else { return }
        viewModel?.onReachBottom()
    }
}

extension ListViewController: Viewable {}


