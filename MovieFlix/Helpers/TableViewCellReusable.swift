//
//  TableViewCellReusable.swift
//  MovieFlix
//
//  Created by Vasilis Polyzos on 1/2/24.
//

import Foundation
import UIKit

protocol TableViewCellReusable {
    static var cellIdentifier: String { get }
    static var nibIdentifier: String { get }
    static func dequeueInTableView(_ tableView: UITableView, forIndexPath: IndexPath) -> Self
}

extension UITableViewCell {
    class func dequeueInTableView<T: UITableViewCell>(_ tableView: UITableView, forIndexPath: IndexPath, type: T.Type, identifier: String) -> T {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? T
        if let cell = cell {
            return cell
        } else {
            tableView.register(UINib(nibName: String(describing: Self.self), bundle: nil), forCellReuseIdentifier: identifier)
            return tableView.dequeueReusableCell(withIdentifier: identifier, for: forIndexPath) as! T
        }
    }
}

extension UITableViewCell: TableViewCellReusable {
    static var cellIdentifier: String { return String("\(self)Identifier") }
    static var nibIdentifier: String { return String(describing: Self.self) }
    
    class func dequeueInTableView(_ tableView: UITableView, forIndexPath: IndexPath) -> Self {
        return dequeueInTableView(tableView, forIndexPath: forIndexPath, type: self, identifier: self.cellIdentifier)
    }
    
    class func dequeueInTableView(_ tableView: UITableView, forIndexPath: IndexPath, identifier: String?) -> Self {
        var cellIdentifier: String!
        if let id = identifier {
            cellIdentifier = String("\(self.cellIdentifier)-\(id)")
        } else {
            cellIdentifier = self.cellIdentifier
        }
        return dequeueInTableView(tableView, forIndexPath: forIndexPath, type: self, identifier: cellIdentifier)
    }
}

extension UITableViewCell {
    class func toView() -> Self {
        let cell = Bundle.main.loadNibNamed("\(Self.self)", owner: nil, options: nil)?[0] as! Self
        return cell
    }
}
