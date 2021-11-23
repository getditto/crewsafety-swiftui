//
//  PeersPage.swift
//  Crew Safety
//
//  Created by Maximilian Alexander on 9/26/21.
//

import SwiftUI
import DittoSwift
import Combine
import CombineDitto

struct RemotePeersPage: View {

    class ViewModel: ObservableObject {
        @Published var remotePeers = [DittoRemotePeer]()

        var cancellables = Set<AnyCancellable>()

        init() {
            DataService.shared.ditto.remotePeersPublisher()
                .assign(to: \.remotePeers, on: self)
                .store(in: &cancellables)
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
                            .font(.title2)
                        if let rssi = remotePeer.rssi {
                            Text("Approximate RSSI \(rssi)")
                        }
                        ForEach(remotePeer.connections, id: \.self) { connection in
                            Text(connection)
                                .font(.subheadline)
                        }


                    }
                }
            }
            .navigationBarTitle("Remote Peers")
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
