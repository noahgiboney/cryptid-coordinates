//
//  ReportedComment.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 9/2/24.
//

import Foundation

struct ReportedComment: DataModel {
    var id = UUID().uuidString
    var commentId: String
    var content: String
    var locationId: String
}
