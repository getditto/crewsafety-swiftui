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

        func changeStatusFor(checkPositionItemId: String, status: CheckPositionItemStatus) {
            DataService.shared.changeStatusFor(checkPositionItemId: checkPositionItemId, status: status)
        }
    }

    var checkPositionId: String?
    @StateObject var viewModel = ViewModel()

    var body: some View {
        List {
            ForEach(viewModel.checkPositionItems, id: \._id) { positionItem in
                CheckPositionItemListItemView(title: positionItem.title, details: positionItem.details, checkStatus: positionItem.status, style: positionItem.style)
                    .onCheckTapped { newStatus in
                        viewModel.changeStatusFor(checkPositionItemId: positionItem._id, status: newStatus)
                    }
            }
        }
        .onAppear(perform: {
            viewModel.checkPositionId = self.checkPositionId
        })
        .navigationTitle("Checklist")
    }
}

struct CheckPositionItemsPage_Previews: PreviewProvider {
    static var previews: some View {
        CheckPositionItemsPage()
    }
}
