//
//  ChartListView.swift
//  WarCrimes
//

import SwiftUI

struct ChartListView: View {
    let data: [ChartData]
    
    var body: some View {
        VStack(alignment: .leading)  {
            ForEach(data) { chartData in
                HStack {
                    Text.init("\(chartData.value)")
                        .padding()
                        .frame(minWidth: 72)
                        .font(Font.subheadline.bold())
                        .foregroundColor(.white)
                        .background(
                           Color.init(uiColor: chartData.bgColor)
                        ).cornerRadius(16)
                    
                    Text(chartData.label)
                        .font(.caption)
                        .bold()
                }
            }
        }

    }
}

struct ChartListView_Previews: PreviewProvider {
    static var previews: some View {
        ChartListView(
            data: ChartData.testSet
        )
    }
}
