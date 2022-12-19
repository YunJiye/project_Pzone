//
//  DriveView.swift
//  Pzone
//
//  Created by J on 2022/12/05.
//

import Foundation
import SwiftUI

struct DriveView: View {
        
    var body: some View {
        VStack {
            Image(uiImage: GetRes.sharedInstance().p)
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-50)
                /*
            Image("res")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-50)
                 */
        }
    }
}

struct DriveView_Previews: PreviewProvider {
    static var previews: some View {
        DriveView()
    }
}
