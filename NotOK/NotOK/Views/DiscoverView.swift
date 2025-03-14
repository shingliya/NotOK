import SwiftUI

struct DiscoverView: View {
    let tabHeaders = [
        "Favorites", "All", "Top", "New", "AI", "Meme", "NFT", "Metaverse"
    ]
    
    @State private var selectedTab: Int = 0
    @State private var tabBarScrollState: Int = 0
    @State private var cryptoPriceScrollState: Int? = nil
    
    @State private var searchText = ""
    
    @StateObject private var viewModel = DiscoverViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search", text: $searchText)
                    .textFieldStyle(.plain)
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 15).fill(Color(.systemGray6)))
            .padding(.horizontal)
            .padding(.bottom)
            
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
                if viewModel.isConnected {
                    ScrollView(.horizontal){
                        LazyHStack(spacing: 0){
                            ForEach(tabHeaders.indices, id: \.self){ index in
                                ScrollView {
                                    LazyVStack(alignment: .leading, spacing: 10) {
                                        ForEach(viewModel.coinDetails.sorted(by: { $0.key < $1.key }), id: \.key) { token, price in
                                            NavigationLink(destination: CoinDetailView(tokenPair: token)) {
                                                CoinRow(width: geo.size.width, tokenPair: token, token: price)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
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
                } else {
                    ContentUnavailableView {
                        Label("Unavailable to fetch coins", systemImage: "externaldrive.badge.xmark")
                    }
                }
            }
        }
        .onAppear {
            viewModel.startPolling()
        }
        
    }
}

#Preview {
    DiscoverView()
}

struct CoinRow: View {
    var width: CGFloat
    var tokenPair: String
    var token: CryptoDetail
    
    var body: some View {
        let coinSymbol = tokenPair.split(separator: "-").first ?? ""
        let fullCoinName = CryptoMapper.fullName(for: String(coinSymbol))
        let iconName = CryptoMapper.iconName(for: String(coinSymbol))
        let percentage = token.formattedDeltaPercentage()
        
        HStack(spacing: 15) {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 35, height: 35)
            VStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading) {
                    HStack {
                        Text(coinSymbol)
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    Text(fullCoinName)
                        .fontWeight(.light)
                }
                
            }
            Spacer()
            VStack (alignment: .trailing) {
                Text("$\(token.price)")
                    .fontWeight(.bold)
                Text("\(percentage)%")
                    .fontWeight(.light)
                    .foregroundColor(token.delta.hasPrefix("-") ? .red : .green)
            }
        }
        .padding()
        .frame(width: width)
    }
}
