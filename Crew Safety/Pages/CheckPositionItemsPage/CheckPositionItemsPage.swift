//
//  PosititonsPage.swift
//  Crew Safety
//
//  Created by Maximilian Alexander on 9/26/21.
//

import SwiftUI
import Combine
import CombineDitto

struct CheckPositionItemsPage: View {

    class ViewModel: ObservableObject {
        @Published var checkPositionItems: [CheckPositionItem] = []
        var cancellables = Set<AnyCancellable>()

        var checkPositionId: String? {
            didSet {
                guard let checkPositionId = self.checkPositionId else { return }
                cancellables.removeAll()

                DataService
                    .shared
                    .checkPositionItems(checkPositionId: checkPositionId)
                    .assign(to: \.checkPositionItems, on: self)
                    .store(in: &cancellables)
            }
        }

        func changeStatusFor(checkPositionItemIds: [String], status: CheckPositionItemStatus) {
            DataService.shared.changeStatusFor(checkPositionItemIds: checkPositionItemIds, status: status)
        }

        func changeAllTo(status: CheckPositionItemStatus) {
            let statusIds = self.checkPositionItems.map({ $0._id })
            DataService.shared.changeStatusFor(checkPositionItemIds: statusIds, status: status)
        }
    }

    var checkPositionId: String?
    @StateObject var viewModel = ViewModel()

    var body: some View {
        List {
            ForEach(viewModel.checkPositionItems, id: \._id) { positionItem in
                CheckPositionItemListItemView(title: positionItem.title, details: positionItem.details, checkStatus: positionItem.status, style: positionItem.style)
                    .onCheckTapped { newStatus in
                        viewModel.changeStatusFor(checkPositionItemIds: [positionItem._id], status: newStatus)
                    }
            }
        }
        .onAppear(perform: {
            viewModel.checkPositionId = self.checkPositionId
        })
        .toolbar(content: {
            Menu {
                ForEach(CheckPositionItemStatus.allCases) { status in
                    Button(action: {
                        viewModel.changeAllTo(status: status)
                    }) {
                        Text("Mark all as \(status.friendlyName)")
                    }
                }
            } label: {
                Label("Change All", systemImage: "pencil")
            }

        })
        .navigationTitle("Checklist")
    }
}

struct CheckPositionItemsPage_Previews: PreviewProvider {
    static var previews: some View {
        CheckPositionItemsPage()
    }
}
