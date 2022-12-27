//
//  PieChartView.swift
//  WarCrimes
//

import SwiftUI


struct PieChartView: View {
    var title: String
    var data: [ChartData]
    
    @State private var currentValue = ""
    @State private var currentLabel = ""
    @State private var touchLocation: CGPoint = .init(x: -1, y: -1)
    
    var pieSlices: [PieSliceData] {
        var slices = [PieSliceData].init()
        data.enumerated().forEach {(index, data) in
                 let value = normalizedValue(index: index, data: self.data)
                 if slices.isEmpty    {
                     slices.append((.init(startDegree: 0, endDegree: value * 360)))
                 } else {
                     slices.append(.init(startDegree: slices.last!.endDegree,    endDegree: (value * 360 + slices.last!.endDegree)))
                 }
             }
         return slices
    }
    
    var pieSection: some View {
        ZStack {
            GeometryReader { geometry in
                ZStack  {
                    ForEach(data.indices, id: \.self){ i in
                        PieSlice(
                            center: CGPoint(
                                x: geometry.frame(in: .local).midX,
                                y: geometry.frame(in:  .local).midY
                            ),
                            radius: geometry.frame(in: .local).width/2,
                            startDegree: pieSlices[i].startDegree,
                            endDegree: pieSlices[i].endDegree,
                            isTouched: sliceIsTouched(index: i, inPie: geometry.frame(in:  .local)),
                            accentColor: Color.init(uiColor: data[i].bgColor),
                            separatorColor: .clear
                        )
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ position in
                            let pieSize = geometry.frame(in: .local)
                            touchLocation = position.location
                            updateCurrentValue(inPie: pieSize)
                         })
                        .onEnded({ _ in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation(Animation.easeOut) {
                                    resetValues()
                                }
                            }
                        })
                )
            }
            .aspectRatio(contentMode: .fit)
            .padding().padding(.horizontal)
            
            VStack  {
                if !currentLabel.isEmpty   {
                    Text(currentLabel)
                        .font(.caption)
                        .bold()
                        .foregroundColor(.black)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).shadow(radius: 3))
                }
                
                if !currentValue.isEmpty {
                    Text("\(currentValue)")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.black)
                        .padding(5)
                        .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).shadow(radius: 3))
                }
            }
            .padding()
        }
    }
    
    var body: some View {
  
        List.init {
            Section.init {
                HStack.init(alignment: .center) {
                    Spacer.init()
                    pieSection
                        .frame(maxWidth: 500)
                    Spacer.init()

                }
            } header: {
                Text.init(title).font(.title2)
            }
            
            Section.init {
                ChartListView(data: data)
            }


        }
        
    }
    
    
}

// MARK: PieChartView- Animations
extension PieChartView {
    func normalizedValue(index: Int, data: [ChartData]) -> Double {
         var total = 0.0
         data.forEach { data in
             total += Double(data.value)
         }
         return Double(data[index].value)/total
     }
    
    func sliceIsTouched(index: Int, inPie pieSize: CGRect) -> Bool {
         guard let angle =   angleAtTouchLocation(inPie: pieSize, touchLocation: touchLocation) else { return false }
         return pieSlices.firstIndex(where: { $0.startDegree < angle && $0.endDegree > angle }) == index
     }

    
    func resetValues() {
         currentValue = ""
         currentLabel = ""
         touchLocation = .init(x: -1, y: -1)
     }
    
    func updateCurrentValue(inPie   pieSize:    CGRect)  {
         guard let angle = angleAtTouchLocation(inPie: pieSize, touchLocation: touchLocation)    else    {return}
         let currentIndex = pieSlices.firstIndex(where: { $0.startDegree < angle && $0.endDegree > angle }) ?? -1
        guard currentIndex > 0 && currentIndex < data.count else { return }
         currentLabel = data[currentIndex].label
         currentValue = "\(data[currentIndex].value)"
     }
    
    func angleAtTouchLocation(inPie pieSize: CGRect, touchLocation: CGPoint) ->  Double?  {
         let dx = touchLocation.x - pieSize.midX
         let dy = touchLocation.y - pieSize.midY
         
         let distanceToCenter = (dx * dx + dy * dy).squareRoot()
         let radius = pieSize.width/2
         guard distanceToCenter <= radius else {
             return nil
         }
         let angleAtTouchLocation = Double(atan2(dy, dx) * (180 / .pi))
         if angleAtTouchLocation < 0 {
             return (180 + angleAtTouchLocation) + 180
         } else {
             return angleAtTouchLocation
         }
     }

}

// MARK: Preview
struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView(
            title: "MyPieChart", data: ChartData.testSet
        )
    }
}
