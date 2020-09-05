//
//  String+Extensions.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 22/08/2020.
//  Copyright © 2020 Palringo. All rights reserved.
//

import Foundation

extension String {

    func htmlAttributedString() -> NSMutableAttributedString {
        guard let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false) else { return NSMutableAttributedString() }

        guard let formattedString = try? NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil ) else { return NSMutableAttributedString() }
        return formattedString
    }

}
