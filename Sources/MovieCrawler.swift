////
////  MovieCrawler.swift
////  PerfectTemplate
////
////  Created by Mi Zhengdi on 26/05/2017.
////
////
//
////自定义一个错误处理
//struct crawlerError:Error
//{
//    var message:String
//    
//    init(msg:String)
//    {
//        message = msg
//    }
//}
//
//extension String
//{
//    //去掉字符串(空格之类的)
//    func trim(string:String) -> String
//    {
//        return self == "" ? "" : self.trimmingCharacters(in: CharacterSet(charactersIn: string))
//    }
//    //替换从末尾出现的第一个指定字符串
//    func replace(of pre:String,with next:String)->String
//    {
//        return replacingOccurrences(of: pre, with: next, options: String.CompareOptions.backwards, range: index(endIndex, offsetBy: -2)..<endIndex)
//    }
//}
//
//class MovieCrawler {
//    private var url: String = ""
//    internal var results = ""
//    
//    init(url: String) {
//        self.url = url
//    }
//    
//    internal func start() {
//        do
//        {
//            try handleData(data: setUp(urlString: url))
//        }
//        catch
//        {
//            debugPrint(error)
//        }
//    }
//    
//    private func setUp(urlString:String) throws ->[String]
//    {
//        //目的就是抓到口碑榜上的那些url
//        var URLArray = [String]()
//        
//        if let url = URL(string:urlString)
//        {
//            debugPrint("开始获取url")
//            //通过创建Scanner
//            let scanner = Scanner(string: try String(contentsOf:url))
//            
//            while !scanner.isAtEnd
//            {
//                //以及首尾字段的定位，抓出url
//                URLArray.append(scanWith(head:"{from:'mv_rk'})\" href=\"",foot:"\">",scanner:scanner))
//            }
//            
//            if URLArray.count == 0
//            {
//                throw crawlerError(msg:"数据初始化失败")
//            }
//            
//            debugPrint("获取url结束")
//        }
//        else
//        {
//            throw crawlerError(msg:"查询URL初始化失败")
//        }
//        return URLArray.filter{$0.characters.count > 0}
//    }
//    
//    //因为要改变
//    private mutating func handleData(data:[String]) throws
//    {
//        debugPrint("开始获取信息")
//        
//        var index = 0
//        
//        //映射成url数组
//        for case let url in data.map({ URL(string:$0) })
//        {
//            guard let _ = url else { throw crawlerError(msg:"数据\(index)初始化失败") }
//            
//            DispatchQueue.global().sync
//                {
//                    do
//                    {
//                        let scanner = Scanner(string: try String(contentsOf:url!))
//                        
//                        //创建一个head & foot 元组，方便处理
//                        var (head,foot) = ("data-name=",".jpg")
//                        
//                        //电影模型
//                        var tempStr = (head + self.scanWith(head:head,foot:foot,scanner:scanner) + foot).components(separatedBy: "data-").map{
//                            "\"\($0)".replacingOccurrences(of: "=", with: "\":").trim(string:" ")
//                        }
//                        
//                        tempStr.removeFirst()
//                        
//                        var content = ""
//                        
//                        _ = tempStr.map{ content += "\($0),\n" }
//                        
//                        content = content.replace(of: ",", with: "\"")
//                        
//                        //电影简介
//                        var intro = ""
//                        
//                        (head,foot) = try String(contentsOf:url!).contains(string: "<span class=\"all hidden\">") ? ("<span class=\"all hidden\">","</span>") : ("<span property=\"v:summary\" class=\"\">","</span>")
//                        
//                        _ = self.scanWith(head:head,foot:foot,scanner:scanner).components(separatedBy: "<br />").map{
//                            intro += $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//                        }
//                        //手动拼成JSON
//                        results += "\"\(index)\":{\"content\":{\(content)},\"intro\":\"\(intro)\"},"
//                    }
//                    catch
//                    {
//                        debugPrint(error)
//                    }
//            }
//            index += 1
//        }
//        
//        debugPrint("获取信息结束")
//        
//        results = results.replace(of: ",", with: "")
//        results = results.characters.count > 0 ? "{\(results)}" : ""
//    }
//    
//    
//    private func scanWith(head:String,foot:String,scanner:Scanner)->String
//    {
//        var str:NSString?
//        
//        scanner.scanUpTo(head, into: nil)
//        scanner.scanUpTo(foot, into: &str)
//        
//        return str == nil ? "" : str!.replacingOccurrences(of: head, with: "")
//    }
//}
