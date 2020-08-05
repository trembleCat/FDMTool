

/// 表单登录教程
func loginWithFormData(params: FetchDataParam,success: @escaping (_ data: String)->(), failure: @escaping (_ failure: String,_ code:Int)->()){
    
    var baseUrl: String = AppConfig.share.getCompanyConfigOnline(name: AppConfig.key_oa_host_v3) ?? Settings.share.oaHost()
    let temp = baseUrl
    if temp[temp.index(temp.endIndex, offsetBy: -1)..<temp.endIndex] == "/" {
        let index = temp.index(temp.startIndex, offsetBy: temp.count-1)
        baseUrl = String(temp[..<index])
    }
    
    if params.url() != "" {
        if params.url()[..<params.url().index(params.url().startIndex, offsetBy: 1)] != "/" {
            var temp = baseUrl
            temp += "/"
            baseUrl = temp
        }
    }
    
    var postURL: String
    if params.url().contains("http") {
        postURL = params.url()
    } else {
        postURL = baseUrl + params.url()
    }

    let paramJson = params.paramsJson()
    
    let username = paramJson?["username"] as! String
    let password = paramJson?["password"] as! String
    let grant_type = paramJson?["grant_type"] as! String
    let client_id = paramJson?["client_id"] as! String
    let scope = paramJson?["scope"] as! String
    let client_secret = paramJson?["client_secret"] as! String
    
    FDMQuick.LogWithNetwork(title: "登陆", url: postURL, params: paramJson, message: params.method())
    
    sessionManager.upload(multipartFormData: { (formdata) in
        
        formdata.append(username.data(using: .utf8)!, withName: "username")
        formdata.append(password.data(using: .utf8)!, withName: "password")
        formdata.append(grant_type.data(using: .utf8)!, withName: "grant_type")
        formdata.append(client_id.data(using: .utf8)!, withName: "client_id")
        formdata.append(scope.data(using: .utf8)!, withName: "scope")
        formdata.append(client_secret.data(using: .utf8)!, withName: "client_secret")
        
    }, to: postURL) { (result) in
        switch  result{
        case .success(request: let upload,_,_):
            upload.responseString { (data) in
                switch data.result{
                    case .success(let rep):
                        if data.response?.statusCode == 200{
                            success(rep)
                        }else{
                            failure(data.value ?? "",data.response?.statusCode ?? 0)
                        }
                    break
                    case .failure(let err):
                        failure(data.value ?? "",data.response?.statusCode ?? 0)
                        
                    break
                }
            }
            break
        case .failure(let error):
            failure("登录失败 \(error)",0)
            break
        }
    }
    
}
