import Foundation
import Firebase

class DataService {
    
    enum DataErrors: ErrorType {
        case MissingSessionData(sessionKey: String)
    }
    
    let USER_PROFILES = "user_profiles"
    let HA_PROFILES = "ha_profiles"
    let MESSAGE_CENTER = "message_center"
    
    static let dataService = DataService()
    
    private var _BASE_REF = Firebase(url: "\(BASE_URL)")
    private var _USER_REF = Firebase(url: "\(BASE_URL)/users")
    private var _HA_QUEUE_REF = Firebase(url: "\(BASE_URL)/ha_queue")
    
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
        return Firebase(url: "\(USER_REF)").childByAppendingPath(userID)
    }
    
    var USER_PROFILE_REF: Firebase {
        let userID = SessionManager.session[USER_ID] as! String
        return Firebase(url: "\(BASE_REF)").childByAppendingPath(USER_PROFILES).childByAppendingPath(userID)
    }
    
    var HA_PROFILE_REF: Firebase {
        let userProfile = SessionManager.session[USER_PROFILE] as! UserProfile
        return Firebase(url: "\(BASE_REF)").childByAppendingPath(HA_PROFILES).childByAppendingPath(userProfile.healthAssistantId)
    }
    
    var MY_MESSAGE_CENTER: Firebase {
        let userID = SessionManager.session[USER_ID] as! String
        return Firebase(url: "\(BASE_REF)")
            .childByAppendingPath(MESSAGE_CENTER)
            .childByAppendingPath(userID)
    }
    
    var HA_MESSAGE_CENTER: Firebase {
        let userProfile = SessionManager.session[USER_PROFILE] as! UserProfile
        let userID = SessionManager.session[USER_ID] as! String
        
        return Firebase(url: "\(BASE_REF)")
            .childByAppendingPath(MESSAGE_CENTER)
            .childByAppendingPath(userProfile.healthAssistantId)
            .childByAppendingPath(userID)
    }
    
    var REMOTE_USER_MESSAGE_CENTER: Firebase {
        
        guard let remoteUserId = SessionManager.session[REMOTE_USER_ID] as? String else {
            // Can't do this in Swift 2, computed properties can't throw
            // throw DataErrors.MissingSessionData(sessionKey: REMOTE_USER_ID)
            // And by the way this sucks too...I need an error mananger...
            return Firebase(url: "\(BASE_REF)")
                .childByAppendingPath(MESSAGE_CENTER)
        }
        
        guard let userID = SessionManager.session[USER_ID] as? String else {
            // Can't do this in Swift 2, computed properties can't throw
            // throw DataErrors.MissingSessionData(sessionKey: USER_ID)
            // And by the way this sucks too...I need an error mananger...
            return Firebase(url: "\(BASE_REF)")
                .childByAppendingPath(MESSAGE_CENTER)
        }
        
        return Firebase(url: "\(BASE_REF)")
            .childByAppendingPath(MESSAGE_CENTER)
            .childByAppendingPath(remoteUserId)
            .childByAppendingPath(userID)
    }
    
    func writeToRemoteHa(message: ChatMessage) {
        DataService.dataService.HA_MESSAGE_CENTER.childByAppendingPath("messages").childByAutoId().setValue(message.asDictionary())
    }

    func writeToRemoteUser(message: ChatMessage) {
        DataService.dataService.REMOTE_USER_MESSAGE_CENTER.childByAppendingPath("messages").childByAutoId().setValue(message.asDictionary())
    }
    
    func observeMyMessageCenter(closure: FirebaseObserveEventType) -> FirebaseObserveEventType {
        return { snapshot -> Void in
            closure(snapshot: snapshot)
        }
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
    
    func processMessages(messageHistory: Dictionary<String, String>, newMessages: Dictionary<String, String>) -> Array<String> {
        var processedMessages = newMessages
        let oldMessageKeys = Set(messageHistory.keys)
        
        for key in oldMessageKeys {
            processedMessages.removeValueForKey(key)
        }
        
        return Array(processedMessages.values)
    }

    func processChatMessages(messageHistory: Dictionary<String, ChatMessage>, newMessages: Dictionary<String, AnyObject>) -> Dictionary<String, ChatMessage> {
        
        var processedMessages = newMessages
        let oldMessageKeys = Set(messageHistory.keys)
        
        for key in oldMessageKeys {
            processedMessages.removeValueForKey(key)
        }
        
        var chatMessages = [String: ChatMessage]()
        
        for (key, value) in processedMessages {
            if let chatDictionary = value as? Dictionary<String, AnyObject> {
                chatMessages[key] = ChatMessage.init(jsonDictionary: chatDictionary)
            }
        }
        
        return chatMessages
    }


}




