//
//  ModuleIconSearcherViewController.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

class ModuleIconSearcherViewController: UIViewController, ModuleIconSearcherViewProtocol {
        
    var presenter: ModuleIconSearcherPresenterProtocol!
    private lazy var customView = self.view as? ModuleIconSearcherView
    
    override func loadView() {
        view = ModuleIconSearcherView(frame: .zero,
                        tableViewDelegate: self,
                        tableViewDataSource: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customView?.getTableView().register(ModuleIconSearcherTableViewCell.self, forCellReuseIdentifier: ModuleIconSearcherTableViewCell.reuseID)
        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customView?.reloadDataTableView()
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    // MARK: - MainViewProtocol
    
    func reloadData() {
        DispatchQueue.main.async {
            self.customView?.reloadDataTableView()
        }
    }
    
    private func configureCell(_ cell: ModuleIconSearcherTableViewCell, with icon: IconModel) {
        cell.configure(icon: icon)
        if let rasterSize = icon.raster_sizes.last {
            cell.sizeLabel.text = "\(rasterSize.size_width)x\(rasterSize.size_height)"
            cell.tagsLabel.text = "Tags: \(icon.tags.prefix(10).joined(separator: ", "))"
        } else {
            cell.sizeLabel.text = "No format available"
            cell.tagsLabel.text = "No tags available"
        }
    }
}

// MARK: UISearchBarDelegate

extension ModuleIconSearcherViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchIcons(with: searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchIcons(with: "")
    }
}

// MARK: UITableViewDataSource

extension ModuleIconSearcherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getIconCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ModuleIconSearcherTableViewCell.reuseID, for: indexPath) as? ModuleIconSearcherTableViewCell,
              let icon = presenter.getIcon(at: indexPath.row) else {
            return UITableViewCell()
        }
        
        configureCell(cell, with: icon)
        return cell
    }
}

// MARK: UITableViewDelegate

extension ModuleIconSearcherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = (tableView.frame.width - 32) / 3
        let height = width * 3
        return height
    }
}
