import Foundation
import Firebase

class DataService {
    static let dataService = DataService()
    
    private var _BASE_REF = Firebase(url: "\(BASE_URL)")
    private var _USER_REF = Firebase(url: "\(BASE_URL)/users")
    private var _HA_QUEUE_REF = Firebase(url: "\(BASE_URL)/ha_queue")
    private var _USER_PROFILE_REF = Firebase(url: "\(BASE_URL)/user_profiles")
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
        let userID = SessionManager.session[USER_ID]
        
        let currentUser = Firebase(url: "\(BASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
        
        return currentUser!
    }
    
    var USER_PROFILE_REF: Firebase {
        let userID = SessionManager.session[USER_ID]
        
        let currentUserProfile = Firebase(url: "\(BASE_REF)").childByAppendingPath("user_profiles").childByAppendingPath(userID)
        
        return currentUserProfile!
    }
    
    
    var USER_CHAT_SESSION_REF: Firebase {
        let userID = SessionManager.session[USER_ID]
        
        let currentUserChatSession = Firebase(url: "\(BASE_REF)").childByAppendingPath("user_chat_sessions").childByAppendingPath(userID)
        
        return currentUserChatSession!
    }
    
    
    func createNewAccount(uid: String, user: Dictionary<String, String>) {
        USER_REF.childByAppendingPath(uid).setValue(user)
    }
}