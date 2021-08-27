//
//  ViewController.swift
//  NewsApp
//
//  Created by Tomashchik Daniil on 21/08/2021.
//

import UIKit
import SafariServices
import Network

class ViewController: UIViewController {

    //MARK: - let
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    let cellMonitor = NWPathMonitor(requiredInterfaceType: .cellular)
    
    //MARK: - var
    var viewModel = NewsListViewModel()
    var spinner = UIActivityIndicatorView()
    lazy var headerView:HeaderView={
        let view = HeaderView(fontSize: 32)
        return view
    }()
    var countForTitlte = 0
    var titlesFortable = ["News for last 24 hours","News for last 2 days","News for last 3 days","News for last 4 days","News for last 5 days","News for last 6 days","News for last 7 days"]
    private let seartchVC = UISearchController(searchResultsController: nil)
    let refreshControl = UIRefreshControl()
    var loadingData = false
    
    lazy var tableView :UITableView={
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.tableFooterView = UIView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: viewModel.reusedID)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    
    //MARK:- VC life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInternetConnection()
        setupView()
        createSeartchBar()
        createRefreshControl()
    }
    
    //MARK:- objc
    @objc func refresh(_ sender: AnyObject) {
        countForTitlte = 0
        viewModel.countOfTime = 1
        viewModel.getNews { _ in
            self.tableView.reloadData()
        }
        refreshControl.endRefreshing()
    }
    
    //MARK:-func
    func setupView () {
        view.addSubview(headerView)
        view.addSubview(tableView)
        setupConstraints()
        fetchNews()
    }
    
    func createRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func checkInternetConnection(){
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "No internet connection", message: "Please check", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Go to settings", style: .default,handler:{ action  in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                                   return
                               }
                               if UIApplication.shared.canOpenURL(settingsUrl) {
                                   UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                   })
                               }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func createSeartchBar()  {
        navigationItem.searchController = seartchVC
        seartchVC.searchBar.delegate = self
    }
    
    func setupConstraints()  {
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor,constant: 8),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func fetchNews()  {
        viewModel.getNews { _ in
            self.tableView.reloadData()
        }
    }
}
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.reusedID,for: indexPath) as? NewsTableViewCell
        let news = viewModel.newsVM[indexPath.row]
        cell?.newsVM = news
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.newsVM.count-8{
            if viewModel.countOfTime < 7{
                countForTitlte += 1
                viewModel.countOfTime += 1
                loadingData = true
                refreshResults()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        return titlesFortable[countForTitlte]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.newsVM.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = viewModel.newsVM[indexPath.row]
        guard let url = URL(string: news.url) else {
            return
        }
        let config = SFSafariViewController.Configuration()
        let safariViewController = SFSafariViewController(url: url, configuration: config)
        safariViewController.modalPresentationStyle = .formSheet
        present(safariViewController, animated: true, completion: nil)
    }
    
    func refreshResults() {
        self.viewModel.moreInfo { _ in
            self.tableView.reloadData()
        }
    }
}
extension ViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        viewModel.getNewsFromSeartch(text: text) { _ in
            self.tableView.reloadData()
        }
    }
}
