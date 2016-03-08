import Foundation
import Firebase

class DataService {
    static let dataService = DataService()
    
    private var _BASE_REF = Firebase(url: "\(BASE_URL)")
    private var _USER_REF = Firebase(url: "\(BASE_URL)/users")
    private var _HA_QUEUE_REF = Firebase(url: "\(BASE_URL)/ha_queue")
    private var _USER_PROFILE_REF = Firebase(url: "\(BASE_URL)/user_profiles")
    private var _HA_PROFILE_REF = Firebase(url: "\(BASE_URL)/ha_profiles")
    private var _USER_CHAT_SESSION_REF = Firebase(url: "\(BASE_URL)/user_chat_sessions")
    
    var BASE_REF: Firebase {
        return _BASE_REF
    }
    
    var USER_REF: Firebase {
        return _USER_REF
    }

    var HA_QUEUE_REF: Firebase {
        return _HA_QUEUE_REF
    }
    
    var CURRENT_USER_REF: Firebase {
        let userID = SessionManager.session[USER_ID] as! String
        return Firebase(url: "\(BASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
    }
    
    var USER_PROFILE_REF: Firebase {
        let userID = SessionManager.session[USER_ID] as! String
        return Firebase(url: "\(BASE_REF)").childByAppendingPath("user_profiles").childByAppendingPath(userID)
    }
    
    var HA_PROFILE_REF: Firebase {
        let userProfile = SessionManager.session[USER_PROFILE] as! UserProfile
        return Firebase(url: "\(BASE_REF)").childByAppendingPath("ha_profiles").childByAppendingPath(userProfile.healthAssistantId)
    }
    
    var USER_CHAT_SESSION_REF: Firebase {
        let userID = SessionManager.session[USER_ID] as! String
        return Firebase(url: "\(BASE_REF)").childByAppendingPath("user_chat_sessions").childByAppendingPath(userID)
    }
    
    func createNewAccount(uid: String, user: Dictionary<String, String>) {
        USER_REF.childByAppendingPath(uid).setValue(user)
    }
    
    func downloadImage(urlString: String, completionHandler: ImageDownloadCompletionType) {
        let request = NSURLRequest(URL: NSURL(string: urlString)!)

        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error != nil {
                print("Failed to load image for url: \(urlString), error: \(error?.description)")
                return
            }
            
            guard let httpResponse = response as? NSHTTPURLResponse else {
                print("Not an NSHTTPURLResponse from loading url: \(urlString)")
                return
            }
            
            if httpResponse.statusCode != 200 {
                print("Bad response statusCode: \(httpResponse.statusCode) while loading url: \(urlString)")
                return
            }
            
            completionHandler(data: data, response: response, error: error)
        }.resume()
    }
}




