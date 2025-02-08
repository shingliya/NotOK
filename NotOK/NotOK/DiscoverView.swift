import SwiftUI

struct DiscoverView: View {
    let tabHeaders = [
        "Favorites", "All", "Top", "New", "AI", "Meme", "NFT", "Metaverse"
    ]
    
    @State private var selectedTab: Int = 0
    @State private var tabBarScrollState: Int = 0
    @State private var cryptoPriceScrollState: Int? = nil
    
    var body: some View {
        VStack{
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(tabHeaders.indices, id: \.self) { index in
                            Button(action: {
                                withAnimation(.snappy) {
                                    selectedTab = index
                                    tabBarScrollState = index
                                    cryptoPriceScrollState = index
                                }
                            }, label: {
                                Text(tabHeaders[index])
                                    .foregroundStyle(selectedTab == index ? Color.primary : . gray)
                                    .font(.title3)
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
            
            GeometryReader { geo in
                ScrollView(.horizontal){
                    LazyHStack(spacing: 0){
                        ForEach(tabHeaders.indices, id: \.self){ index in
                            ScrollView {
                                CryptoCoinPlaceHolderView(width: geo.size.width)
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollPosition(id: $cryptoPriceScrollState)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .onChange(of: cryptoPriceScrollState) { oldIndex, newIndex in
                    if let newIndex {
                        withAnimation(.snappy) {
                            selectedTab = newIndex
                            tabBarScrollState = newIndex
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    DiscoverView()
}

struct CryptoCoinPlaceHolderView: View {
    var width: CGFloat
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 30) {
                Label {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("BTC")
                                .fontWeight(.bold)
                            Text("/ USDT")
                                .fontWeight(.light)
                        }
                        Text("Bitcoin")
                            .fontWeight(.light)
                    }
                } icon : {
                    Image(systemName: "bitcoinsign.circle.fill")
                        .foregroundColor(.orange)
                }
            }
            Spacer()
            VStack (alignment: .trailing) {
                Text("96,229.2")
                    .fontWeight(.bold)
                Text("-0.21%")
                    .fontWeight(.light)
            }
        }
        .padding()
        .frame(width: width)
    }
}
