//
//  PeersPage.swift
//  Crew Safety
//
//  Created by Maximilian Alexander on 9/26/21.
//

import SwiftUI
import DittoSwift
import CombineDitto

struct RemotePeersPage: View {

    class ViewModel: ObservableObject {
        @Published var remotePeers = [DittoRemotePeer]()

        var handler: DittoPeersObserver?

        init() {
            handler = DataService.shared.ditto
                .observePeers { [weak self] peers in
                    self?.remotePeers = peers
                }
        }
    }

    @StateObject var viewModel = ViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.remotePeers) { remotePeer in
                    VStack(alignment: .leading) {
                        Text(remotePeer.deviceName)
                        if let rssi = remotePeer.rssi {
                            Text("Approximate RSSI \(rssi)")
                        }
                    }
                }
            }
            .toolbar {
                Button("Close") {
                    dismiss()
                }
            }
        }
    }
}

struct PeersPage_Previews: PreviewProvider {
    static var previews: some View {
        RemotePeersPage()
    }
}
