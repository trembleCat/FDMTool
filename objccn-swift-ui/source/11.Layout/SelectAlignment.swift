import SwiftUI

extension VerticalAlignment {
    struct SelectAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[VerticalAlignment.center]
        }
    }

    static let select = VerticalAlignment(SelectAlignment.self)
}

struct ContentView: View {

    @State var selectedIndex = 0

    let names = [
        "onevcat | Wei Wang",
        "zaq | Hao Zang",
        "tyyqa | Lixiao Yang"
    ]

    var body: some View {
        HStack(alignment: .select) {
            Text("User:")
                .font(.footnote)
                .foregroundColor(.green)
                .alignmentGuide(.select) { d in
                    d[.bottom] + CGFloat(self.selectedIndex) * 20.3
                }
            Image(systemName: "person.circle")
                .foregroundColor(.green)
                .alignmentGuide(.select) { d in
                    d[VerticalAlignment.center]
                }
            VStack(alignment: .leading) {
                ForEach(0..<names.count) { index in
                    Group {
                        if index == self.selectedIndex {
                            Text(self.names[index])
                                .foregroundColor(.green)
                                .alignmentGuide(.select) { d in
                                    d[VerticalAlignment.center]
                                }
                        } else {
                            Text(self.names[index])
                                .onTapGesture {
                                    self.selectedIndex = index
                                }
                        }
                    }
                }
            }
        }
        .animation(.linear(duration: 0.2))
        .lineLimit(1)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
