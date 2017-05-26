//
//  ContentOperator.swift
//  PerfectTemplate
//
//  Created by Mi Zhengdi on 25/05/2017.
//
//

import StORM
import MySQLStORM

class ContentOperator {
    
    func addContent(title: String, content: String) -> Content? {
        let ct = Content()
        ct.title = title
        ct.content = content
        
        do {
            try ct.create()
        } catch {
            
        }
        
        return ct
    }

    func queryContentWithId(contentId: String) -> Content? {
        let getObj = Content()
        
        do {
            try getObj.get(contentId)
        } catch {
            
        }
        
        return getObj
    }

    func queryContentList() -> [Content]? {
        var arr = [Content]()
        
        let getObj = Content()
        
        do {
            try getObj.findAll()
            
            for row in getObj.rows() {
                arr.append(row)
            }
        } catch {
            
        }
        
        return arr
    }

}
