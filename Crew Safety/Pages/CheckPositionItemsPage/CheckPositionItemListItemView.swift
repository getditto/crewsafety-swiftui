//
//  CheckRowListItemView.swift
//  Crew Safety
//
//  Created by Maximilian Alexander on 9/26/21.
//

import SwiftUI

struct CheckPositionItemListItemView: View {

    var title: String
    var details: String
    var checkStatus: CheckPositionItemStatus
    var style: CheckStyle

    var goodButtonSystemImage: String {
        switch checkStatus {
        case .good:
            return "\(style.rawValue).fill"
        default:
            return style.rawValue
        }
    }

    var goodButtonForegroundColor: Color {
        switch checkStatus {
        case .good:
            return .green
        default:
            return .secondary
        }
    }

    var badButtonSystemImage: String {
        switch checkStatus {
        case .bad:
            return "\(style.rawValue).fill"
        default:
            return style.rawValue
        }
    }

    var badButtonForegroundColor: Color {
        switch checkStatus {
        case .bad:
            return .red
        default:
            return .secondary
        }
    }


    
    var tappedCheckCallback: ((CheckPositionItemStatus) -> Void)?

    func onCheckTapped(_ callback: @escaping (CheckPositionItemStatus) -> Void) -> Self {
        var copy = self
        copy.tappedCheckCallback = callback
        return copy
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title3)
            HStack {
                Text(details)
                Spacer()
                HStack(spacing: 20) {
                    Image(systemName: badButtonSystemImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(badButtonForegroundColor)
                        .onTapGesture {
                            if checkStatus != .bad {
                                tappedCheckCallback?(.bad)
                            }
                            if checkStatus == .bad {
                                tappedCheckCallback?(.none)
                            }
                        }
                    Image(systemName: goodButtonSystemImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(goodButtonForegroundColor)
                        .onTapGesture {
                            if checkStatus != .good {
                                tappedCheckCallback?(.good)
                            }
                            if checkStatus == .good {
                                tappedCheckCallback?(.none)
                            }
                        }
                }

            }
        }
    }
}

struct CheckRowListItemView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                CheckPositionItemListItemView(title: "Beleuchtete Notsausgangsschilder", details: "leuchten", checkStatus: .none, style: .square)
                CheckPositionItemListItemView(title: "Leuchtstreifen am Boden", details: "vollstandig vorhanden", checkStatus: .good, style: .circle)
                CheckPositionItemListItemView(title: "Beleuchtete Notsausgangsschilder", details: "leuchten", checkStatus: .bad, style:  .triangle)
            }
            .listStyle(.plain)
            .navigationTitle("Check Items")
        }

    }
}
