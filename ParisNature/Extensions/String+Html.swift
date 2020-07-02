//
//  String+Html.swift
//  ParisNature
//
//  Created by co5ta on 25/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

extension String {
    /// HTML content converted to NSMutableAttributedString
    var htmlToAttributedString: NSMutableAttributedString? {
        guard let data = data(using: .utf8),
            let string = try? NSMutableAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)
            else { return nil }
        string.addAttributes([.font: UIFont.preferredFont(forTextStyle: .callout), .foregroundColor: Style.label],
                             range: NSRange(0..<string.length))
        return string
    }
}
