//
//  CheckPosititionsListItem.swift
//  Crew Safety
//
//  Created by Maximilian Alexander on 9/26/21.
//

import SwiftUI

struct CheckPosititionsListItemView: View {

    var title: String
    var squareProgress: Float
    var circleProgress: Float
    var triangleProgress: Float

    var isCompleted: Bool {
        return squareProgress >= 1 &&
        circleProgress >= 1 &&
        triangleProgress >= 1
    }

    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.title2)
                Spacer()
                if isCompleted {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "square.fill")
                        .foregroundColor(.red)
                }
            }
            if !isCompleted {
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "square.fill")
                            .foregroundColor(Color.accentColor)
                        ProgressView(value: squareProgress)
                            .tint(Color.yellow)
                            .progressViewStyle(.linear)
                            .scaleEffect(x: 1, y: 2, anchor: .center)
                    }
                    HStack {
                        Image(systemName: "circle.fill")
                            .foregroundColor(Color.accentColor)
                        ProgressView(value: circleProgress)
                            .tint(Color.yellow)
                            .progressViewStyle(.linear)
                            .scaleEffect(x: 1, y: 2, anchor: .center)
                    }
                    HStack {
                        Image(systemName: "triangle.fill")
                            .foregroundColor(Color.accentColor)
                        ProgressView(value: triangleProgress)
                            .tint(Color.yellow)
                            .progressViewStyle(.linear)
                            .scaleEffect(x: 1, y: 2, anchor: .center)
                    }
                }
            }
        }
    }
}

struct CheckPosititionsListItem_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                CheckPosititionsListItemView(title: "FB 1R", squareProgress: 0.9, circleProgress: 0.5, triangleProgress: 0.4)
                CheckPosititionsListItemView(title: "FB 2L", squareProgress: 1, circleProgress: 1, triangleProgress: 1)
                CheckPosititionsListItemView(title: "FB 2R", squareProgress: 1, circleProgress: 1, triangleProgress: 1)
                CheckPosititionsListItemView(title: "FB 2R", squareProgress: 0.2, circleProgress: 0.5, triangleProgress: 1)
            }
            .navigationTitle("Check Positions")
            .listStyle(.plain)
        }
    }
}
