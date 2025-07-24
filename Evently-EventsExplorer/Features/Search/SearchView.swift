//
//  SearchView.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-24.
//

import SwiftUI

struct SearchView: View {
    let container: DIContainer
    var body: some View {
        SearchViewControllerWrapper(container: container)
    }
}

struct SearchViewControllerWrapper: UIViewControllerRepresentable {
    let container: DIContainer

    func makeUIViewController(context _: Context) -> UINavigationController {
        let vc = SearchViewController(container: container)
        return UINavigationController(rootViewController: vc)
    }

    func updateUIViewController(_: UINavigationController, context _: Context) {
        // Nothing to update dynamically for now
    }
}

#Preview {
    SearchView(container: .preview)
}
