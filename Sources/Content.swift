//
//  Content.swift
//  PerfectTemplate
//
//  Created by Mi Zhengdi on 25/05/2017.
//
//

import StORM
import MySQLStORM

class Content: MySQLStORM {
    var id: Int = 0
    var title: String = ""
    var content: String = ""
    
    override open func table() -> String {
        return "content"
    }
    
    override open func to(_ this: StORMRow) {
        id = Int(this.data["id"] as? Int32 ?? 0)
        title = this.data["title"] as? String ?? ""
        content = this.data["content"] as? String ?? ""
    }
    
    func rows() -> [Content] {
        var rows = [Content]()
        
        for i in 0..<self.results.rows.count {
            let row = Content()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        
        return rows
    }
}
