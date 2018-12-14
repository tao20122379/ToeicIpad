//
//  Global.swift
//  ToeicIpad
//
//  Created by DungLM3 on 11/5/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import Foundation
import UIKit

class Global: NSObject {
    static let SCREEN_WIDTH = UIScreen.main.bounds.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.height
    static let CELL_SPEED_HEIGHT = 40
    static let IS_FIRST_LOGIN = "is_first_login"
    static let NOTIFICATION_NEXT = "notification_next"
    static let NOTIFICATION_PREV = "notification_prev"
    static let NOTIFICATION_SELECT_LIST = "notification_select_list"
    static let BASE_URL = "http://testcrm.tomorrowmarketers.org/"
    static let SAFE_AREA_TOP = "safe_area_top"
    static let SAFE_AREA_BOT = "safe_area_bot"
    static let TIMEOUT_INTERVAL = 5.0
    
}
