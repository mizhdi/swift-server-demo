//
//  WebHandlers.swift
//  PerfectTemplate
//
//  Created by Mi Zhengdi on 25/05/2017.
//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectLogger
import PerfectMustache

class DetailMustachePageHandler: MustachePageHandler {
    
    var contentId: String = ""
    
    init(contentId: String) {
        self.contentId = contentId
    }
    
    func extendValuesForResponse(context contxt: MustacheWebEvaluationContext, collector: MustacheEvaluationOutputCollector) {
        var values = MustacheEvaluationContext.MapType()
        
        guard let ct = ContentOperator().queryContentWithId(contentId: contentId) else {
            return;
        }
        values["title"] = ct.title
        values["content"] = ct.content
        contxt.extendValues(with: values)
        
        do {
            try contxt.requestCompleted(withCollector: collector)
        } catch {
            let response = contxt.webResponse
            response.status = .internalServerError
            response.appendBody(string: "\(error)")
            response.completed()
        }
    }
}

open class WebHandlers {
    
    open static func addHandler(request: HTTPRequest, response: HTTPResponse) -> Void {
        guard let title: String = request.param(name: "title") else {
            LogFile.error("title为nil")
            return
        }
        
        guard let content: String = request.param(name: "content") else {
            LogFile.error("content为nil")
            return
        }
        
        guard let _: Content = ContentOperator().addContent(title: title, content: content) else {
            LogFile.error("ct为nil")
            return
        }
        response.status = .movedPermanently
        response.setHeader(.location, value: "/list")
        response.completed()
    }
    
    open static func listHandler(request: HTTPRequest, response: HTTPResponse) -> Void {
        guard let arr: [Content] = ContentOperator().queryContentList() else {
            LogFile.error("arr为nil")
            return
        }
        
        var itemList = [[String: Any]]()
        for item in arr {
            itemList.append(["id": "\(item.id)", "title": item.title, "content": item.content])
        }
        
        let responseJson: [String : Any] = ["list": itemList, "success": "success", "message": ""]
        
        guard let json = try? responseJson.jsonEncodedString() else {
            LogFile.error("json 解析错误")
            response.setBody(string: "没找到你要的内容")
            response.completed()
            
            return
        }
        
        response.setHeader(.contentType, value: "application/json")
        response.setBody(string: json)
        response.completed()
    }
    
    open static func detailHandler(request: HTTPRequest, response: HTTPResponse) -> Void {
        guard let contentId: String = request.urlVariables["contentid"] else {
            LogFile.error("contentId为nil")
            response.setBody(string: "没找到你要的内容")
            response.completed()
            return
        }
        
        let webRoot = request.documentRoot
        
        mustacheRequest(request: request, response: response, handler: DetailMustachePageHandler(contentId:contentId), templatePath: webRoot + "/detail.html")
    }
}
