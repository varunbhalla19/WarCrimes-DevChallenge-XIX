//
//  StatsView.swift
//  WarCrimes
//

import SwiftUI

struct StatsView: View {
    
    @State private var chartSelected: ChartType = .crimes
    
    let viewModel: ChartStats
    
    var body: some View {
        VStack.init {
                        
            Picker("Select Chart Type", selection: $chartSelected) {
                ForEach(ChartType.allCases) { caseType in
                    Text(caseType.rawValue).tag(caseType)
                }
            }.pickerStyle(.segmented)
                .padding()

            switch chartSelected {
            case .crimes:
                PieChartView(
                    title: chartSelected.rawValue,
                    data: viewModel.eventStats
                )
            case .qualif:
                PieChartView(
                    title: chartSelected.rawValue,
                    data: viewModel.qualificationStats
                )

            case .affected:
                PieChartView(
                    title: chartSelected.rawValue,
                    data: viewModel.affectedStats
                )

            case .status:
                PieChartView(
                    title: chartSelected.rawValue,
                    data: viewModel.statusStats
                )

            }
            
        }
    }
}

// MARK: - ChartType
enum ChartType: String, CaseIterable, Identifiable {
    
    var id: Int {
        hashValue
    }
    
    case crimes = "Crimes"
    case affected = "Affected"
    case status = "Status"
    case qualif = "Qualifications"
}

// MARK: - Preview
struct StatsView_Previews: PreviewProvider {
    private class TestStats: ChartStats {
        var eventStats: [ChartData] {
            ChartData.testSet
        }
        
        var qualificationStats: [ChartData] {
            ChartData.qualifTest
        }
        
        var statusStats: [ChartData] {
            ChartData.statusTest
        }
        
        var affectedStats: [ChartData] {
            ChartData.affectedTest
        }
        
        
    }
    
    static var previews: some View {
        StatsView(viewModel: TestStats.init())
    }
}

// MARK: - ChartStats
protocol ChartStats {
    var eventStats: [ChartData] { get }
    var qualificationStats: [ChartData] { get }
    var statusStats: [ChartData] { get }
    var affectedStats: [ChartData] { get }
}

// MARK: - Test ChartData
extension ChartData {
    static let testSet = [
        ChartData(label: "January 2021", value: 150, bgColor: .orange),
        ChartData(label: "February 2021", value: 202, bgColor: .red),
        ChartData(label: "March 2021", value: 390, bgColor: .blue),
        ChartData(label: "April 2021", value: 350, bgColor: .darkGray),
        ChartData(label: "May 2021", value: 460, bgColor: .systemMint),
        ChartData(label: "June 2021", value: 320, bgColor: .purple),
        ChartData(label: "July 2021", value: 50, bgColor: .brown)
    ]
    
    fileprivate static let qualifTest = Self.testSet.shuffled()
    fileprivate static let affectedTest = Self.testSet.shuffled()
    fileprivate static let statusTest = Self.testSet.shuffled()
    

}
