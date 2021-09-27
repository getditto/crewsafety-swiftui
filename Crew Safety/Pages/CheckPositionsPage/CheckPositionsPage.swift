//
//  CheckPositionsPage.swift
//  Crew Safety
//
//  Created by Maximilian Alexander on 9/26/21.
//

import SwiftUI
import Combine

struct CheckPositionsPage: View {

    class ViewModel: ObservableObject {

        var cancellables = Set<AnyCancellable>()
        @Published var checkPositionsWithItems = [CheckPositionWithItems]()

        @Published var isShowingRemotePeersPage = false

        init() {
            DataService.shared.bootstrapWithFakeData()
            DataService.shared
                .checkPositionWithItems
                .assign(to: \.checkPositionsWithItems, on: self)
                .store(in: &cancellables)
        }

        func showRemotePeersPage() {
            isShowingRemotePeersPage = true
        }
    }

    @StateObject var viewModel = ViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.checkPositionsWithItems, id: \.checkPosition._id) { checkPositionWithItems in
                    let title = checkPositionWithItems.checkPosition.title
                    let squareProgress = checkPositionWithItems.squareProgress
                    let circleProgress = checkPositionWithItems.circleProgress
                    let triangleProgress = checkPositionWithItems.triangleProgress
                    NavigationLink {
                        CheckPositionItemsPage(checkPositionId: checkPositionWithItems.checkPosition._id)
                    } label: {
                        CheckPosititionsListItemView(title: title, squareProgress: squareProgress, circleProgress: circleProgress, triangleProgress: triangleProgress)
                    }
                }
            }
            .navigationTitle("Check Positions")
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Remote Peers") {
                        viewModel.showRemotePeersPage()
                    }
                }
            }
            .sheet(isPresented: $viewModel.isShowingRemotePeersPage) {
                RemotePeersPage()
            }
        }
    }
}

struct CheckPositionsPage_Previews: PreviewProvider {
    static var previews: some View {
        CheckPositionsPage()
    }
}
