//
//  ContentView.swift
//  Shared
//
//  Created by Alexander Mason on 10/22/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var model: OpenSeaModel = OpenSeaModel.shared
    
    var body: some View {
        if model.activeProfile != nil {
            ProfileView()
        } else {
            SignInView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
