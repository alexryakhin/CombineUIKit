//
//  ListViewController.swift
//  CombineUIKit
//
//  Created by Alexander Ryakhin on 1/24/22.
//

import UIKit
import Combine
import CombineCocoa
import CombineDataSources

final class ListViewController: UIViewControllerX {
    let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
    let viewModel = ListViewModel()
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupViews()
        applyBindings()
        needToHideNavBar = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { make in
            make.top.trailing.leading.bottom.equalToSuperview()
        }
    }
    
    // MARK: THE WHOLE DATA SOURCE YOU NEED TO GET TABLE VIEW TO WORK!!!!
    private func applyBindings() {
        viewModel.$todos
            .bind(subscriber: tableView.rowsSubscriber(cellIdentifier: "Cell", cellType: UITableViewCell.self, cellConfig: { cell, indexPath, model in
                cell.textLabel?.text = model.title
                cell.imageView?.image = UIImage(systemName: model.completed ? "checkmark.circle" : "circle")
            }))
            .store(in: &cancellables)
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func setupViews() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}
