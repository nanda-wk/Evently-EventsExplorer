//
//  Evently_EventsExplorerApp.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-22.
//

import SwiftUI

@main
struct Evently_EventsExplorerApp: App {
    private let environment = AppEnvironment.bootstrap()

    var body: some Scene {
        WindowGroup {
            Home(viewModel: .init(container: environment.container))
        }
    }
}
