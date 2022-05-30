//
//  Safari.swift
//  
//
//  Created by Ziad Tamim on 05.12.21.
//

import SwiftUI
import SafariServices

public struct Safari: View {
    private let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public var body: some View {
        SFSafari(url: url)
            .ignoresSafeArea()
    }
}

private struct SFSafari: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController(
        _ uiViewController: SFSafariViewController,
        context: UIViewControllerRepresentableContext<SFSafari>
    ) { }
}
