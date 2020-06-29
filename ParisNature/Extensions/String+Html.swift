//
//  String+Html.swift
//  ParisNature
//
//  Created by co5ta on 25/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

extension String {
    var htmlToAttributedString: NSMutableAttributedString? {
        guard let data = data(using: .utf8),
            let string = try? NSMutableAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html,
                          .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)
            else { return nil }
        string.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .callout), range: NSRange(0..<string.length))
        return string
    }
}
