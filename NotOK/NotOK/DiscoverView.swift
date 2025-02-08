import SwiftUI

struct DiscoverView: View {
    let tabHeaders = [
        "United States", "Canada", "United Kingdom", "Germany", "France",
        "Italy", "Spain", "Australia", "Japan", "China"
    ]
    
    @State private var selectedTab: Int = 0
    @State private var tabBarScrollState: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(tabHeaders.indices, id: \.self) { index in
                        Button(action: {
                            withAnimation(.snappy) {
                                selectedTab = index
                                tabBarScrollState = index
                            }
                        }, label: {
                            Text(tabHeaders[index])
                                .foregroundStyle(selectedTab == index ? Color.primary : . gray)
                                .fontWeight(selectedTab == index ? .bold : .regular)
                                .padding(.bottom)
                        })
                        .buttonStyle(.plain)
                    }
                }
            }
            .scrollPosition(id: .init(get: {
                return tabBarScrollState
            }, set: { _ in
                
            }), anchor: .center)
            .safeAreaPadding(.horizontal, 15)
            .overlay(alignment: .bottom) {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                        .frame(height: 2)
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    DiscoverView()
}
