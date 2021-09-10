//
//  View+Extensions.swift
//  SwiftUI-Movies_App
//
//  Created by Arpit Dixit on 10/09/21.
//

import Foundation
import SwiftUI

enum DisplayMode {
    case fullscreen
}

extension View {
    
    var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }
    
    func fullscreen() -> some View {
        return self.frame(width: screenSize.width, height: screenSize.height)
    }
}
