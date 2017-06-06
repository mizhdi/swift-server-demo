//
//  Routes.swift
//  PerfectTemplate
//
//  Created by Mi Zhengdi on 25/05/2017.
//
//

import PerfectLib
import PerfectHTTP

public func signupRoutes() -> Routes {
    var routes = Routes()
    
    routes.add(method: .post, uri: "/add", handler: WebHandlers.addHandler)
    routes.add(method: .get, uri: "/list", handler: WebHandlers.listHandler)
    routes.add(method: .get, uri: "/detail/{contentid}", handler: WebHandlers.detailHandler)
    
    return routes
}
