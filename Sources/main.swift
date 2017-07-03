//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import StORM
import MySQLStORM

//MySQLConnector.host		= "127.0.0.1"
MySQLConnector.host     = "172.17.0.2"
MySQLConnector.username	= "root"
MySQLConnector.password	= "root"
MySQLConnector.database	= "test"
MySQLConnector.port		= 3306

let obj = Content()

try? obj.setup()

// Create HTTP server.
let server = HTTPServer()

server.serverPort = 8181

server.addRoutes(signupRoutes())

server.documentRoot = "./webroot"

server.setResponseFilters([(Filter404(), .high)])

do {
    // Launch the HTTP server.
    try server.start()
    
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}

