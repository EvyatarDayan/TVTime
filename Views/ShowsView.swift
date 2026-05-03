//
//  ShowsView.swift
//  TVTime
//
//  Created by EVYATAR DAYAN on 2025-10-25.
//

import SwiftUI

struct ShowsView: View {
    @State private var series: [Series] = []
    @EnvironmentObject var themeManager: ThemeManager
    @State private var searchText = ""
    
    private let defaultSeries: [Series] = [
        Series(
            name: "הישראלים",
            imageName: "israelim",
            backgroundImageName: "israelim",
            episodes: [
                Episode(episodeNumber: 1, name: "הישראלים, עונה 1, פרק 1", streamURL: "https://cdnapisec.kaltura.com/p/2748741/sp/274874100/playManifest/entryId/1_wfgoxht3/protocol/https/format/applehttp/flavorIds/1_x0n0wkya,1_ndp5ysh0,1_uhoxzi1q,1_qj1pkwy8,1_vutak18z/a.m3u8?uiConfId=50272542&playSessionId=2b8cde66-4b7e-599f-543f-ba0f8314e504:4ec63896-789f-5b21-ced1-7245fea257fa&referrer=aHR0cHM6Ly8xM3R2LmNvLmlsL2FsbHNob3dzL3Nlcmllcy8xNDEv&clientTag=html5:v7.203", imageName: "israelim"),
                Episode(episodeNumber: 2, name: "הישראלים, עונה 1, פרק 2", streamURL: "https://cfvod.kaltura.com/scf/enc/hls/p/2748741/sp/274874100/serveFlavor/entryId/1_ovdo7ave/v/41/ev/25/flavorId/1_9jr6x1fa/name/a.mp4/index.m3u8?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZnZvZC5rYWx0dXJhLmNvbS9zY2YvZW5jL2hscy9wLzI3NDg3NDEvc3AvMjc0ODc0MTAwL3NlcnZlRmxhdm9yL2VudHJ5SWQvMV9vdmRvN2F2ZS92LyoiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE3NjE1MDU4MjR9fX1dfQ__&Signature=A18JWyJx7OuiFi~z~h9PgyHmS-VM6wf2vrn0A~apI-93mI9x4L718GMwpohU4YPOMUfkgj4~kbHZt196DgTmsYRfgEWM9vHeV9sL2VQauQrHwuT03yLCNKYtp78Aw6JD97CKHwyK46f7ixfjPnxKeAYYjb2G8rvnCUMknYeOYcE1hUrTPIsFjbg68D7vNv5Er3Ra~DOdvvs1IdKUGxIYyh7AqpVRRXECYF2q0LbAR4CM1BPPcKabY6iBDuaS-hjFeAhjoFP3fuGEqCT~IFpIAqWG6I8YlPrE~X75sJcWT6yvtFsc8uto4HdKPNF~81RSAOFIip3Mqjbm0MsnfXcKRA__&Key-Pair-Id=APKAJT6QIWSKVYK3V34A", imageName: "israelim"),
                Episode(episodeNumber: 3, name: "הישראלים, עונה 1, פרק 3", streamURL: "https://cfvod.kaltura.com/scf/enc/hls/p/2748741/sp/274874100/serveFlavor/entryId/1_sw784jt7/v/41/ev/22/flavorId/1_eyimzlp2/name/a.mp4/index.m3u8?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZnZvZC5rYWx0dXJhLmNvbS9zY2YvZW5jL2hscy9wLzI3NDg3NDEvc3AvMjc0ODc0MTAwL3NlcnZlRmxhdm9yL2VudHJ5SWQvMV9zdzc4NGp0Ny92LyoiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE3NjE1MDU4NTJ9fX1dfQ__&Signature=K4a65n3l2V8xSJQ~icHuLkZf~C7gIboplof3q1EQ1TDBdVUt6PRJZwfRnwqUky1MPDUsdNeMk0EEJi05L2mAhky~FocpNXFM~E50OWEFnvAhKIQ60mI1NWepRfW~8iWNxhn2bfwxAP0LOOP7Me-0X3KQoUnV14ZqxI9gUUxRaTZ2bmjGDrfsyYHkaFn~X1YKlVvG--hYAdIoAyP~lgN7iSB802nXbQXKbSLrc289Z73WEguAlq~68EF9Ii5vDEZ0jNwCVm~xJIWUUeECfMGXiC3Uv2Wm4-S5jJy0z41E~jtav3KRtCJlxIzBux~58kY3Vd5WhHmLVZWgqZS9eNsOuA__&Key-Pair-Id=APKAJT6QIWSKVYK3V34A", imageName: "israelim"),
                Episode(episodeNumber: 4, name: "הישראלים, עונה 1, פרק 4", streamURL: "https://cfvod.kaltura.com/scf/enc/hls/p/2748741/sp/274874100/serveFlavor/entryId/1_3mogjynk/v/21/ev/21/flavorId/1_8l7muwil/name/a.mp4/index.m3u8?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZnZvZC5rYWx0dXJhLmNvbS9zY2YvZW5jL2hscy9wLzI3NDg3NDEvc3AvMjc0ODc0MTAwL3NlcnZlRmxhdm9yL2VudHJ5SWQvMV8zbW9nanluay92LyoiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE3NjE1MDU4NzF9fX1dfQ__&Signature=S1aMG4ztR2cqHfaFqlDZhB2vLK3vLLcuCN6OO1wlYeN71ZsCKeYybzgLGO2VIyksYGJ2sUULgCi-bX2oRFgh7nYtUWHN-CW-gJzEvafReaPelS1nnp1a7jp4H5Lwn1NQUIi-zaI8beYnxG69fAcOdkFHWuTR6hO9zs5V457V2oDxaMOaLcmzozqFjOtK7fw16P7tGNmGQA5BTG7kcZX6Ef2mRq37C4Jod0hk4zuBU9ELiGLvy5XB3gY1Dmv1c46FAjINqD~lsqZNWpu1WYj21cYSIzQIQF9VHfx6Ktt1Pd8lHuikTwSCfaA~8voaWIn6s2tEgZx-lH3iXmFu4bGE3g__&Key-Pair-Id=APKAJT6QIWSKVYK3V34A", imageName: "israelim"),
                Episode(episodeNumber: 5, name: "הישראלים, עונה 1, פרק 5", streamURL: "https://cfvod.kaltura.com/scf/enc/hls/p/2748741/sp/274874100/serveFlavor/entryId/1_k2hm0wgd/v/31/ev/18/flavorId/1_r9idht16/name/a.mp4/index.m3u8?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZnZvZC5rYWx0dXJhLmNvbS9zY2YvZW5jL2hscy9wLzI3NDg3NDEvc3AvMjc0ODc0MTAwL3NlcnZlRmxhdm9yL2VudHJ5SWQvMV9rMmhtMHdnZC92LyoiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE3NjE1MDU4OTF9fX1dfQ__&Signature=TlZ9DYCLw4UJWd6cr2bKZcgCQiV1hUL2Z~8nUCX6IwKGIuUROwjpUFTEIo-~sP-K6Pua2dAuHb3magBQ-RRB5EtKYQQ5oS-qMEuTtTQwq0BVFgJr824jY6o7~mwaTQ1pGC2Rf05Iv-ShOLnQAL5njWmeYtOv9FF2MQtOMbeNi4f5a5SKwhUgcgAteQH6AZ5hsFNo9sTcIGHvkuAGt077V2~hKVjyqsGe1MitEnQV81OvM~8GWYADcs8X2ahNYhCAWwyZmyMnkoAoDD7BRpby-U5LeIZ6uXRq97jdDf2xsEjcW58ZgE-ROrN5gicghIS0TovUa5nEAJyneeHcINfsJg__&Key-Pair-Id=APKAJT6QIWSKVYK3V34A", imageName: "israelim"),
                Episode(episodeNumber: 6, name: "הישראלים, עונה 1, פרק 6", streamURL: "https://cfvod.kaltura.com/scf/enc/hls/p/2748741/sp/274874100/serveFlavor/entryId/1_5bh5f332/v/31/ev/18/flavorId/1_447x59yv/name/a.mp4/index.m3u8?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZnZvZC5rYWx0dXJhLmNvbS9zY2YvZW5jL2hscy9wLzI3NDg3NDEvc3AvMjc0ODc0MTAwL3NlcnZlRmxhdm9yL2VudHJ5SWQvMV81Ymg1ZjMzMi92LyoiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE3NjE1MDU5MTF9fX1dfQ__&Signature=LkwfzHXDdWT7PTEUMthO-uhGR7YxHEWgycDocXx6OOxXneafNsTLqvKsFTj1kpFuozj3-iO999PMTZxlX0bWvw5tujJC2o-dRKj-iEf8GA8O73inp9zR8QmPePfwFSjhhVK6T4HpLYo6kjYyW6ZFf~fcuJKpe8lVFiprak1E3CGzkbNoiuwgF-raLYDafQZ7dRXYls7Kb2m7TKK0kJm~Bkpm7UIyowW6wEhI75~cPRDpDJ99VHVn6DowtLZymAGeLUdzUmE~AuYg-Lq4~iVkAVTvzPMtmQBXAm1x1zbx5ZjzCgZNyQUBrTV2uVbwzkyTzJ-uZp4gdMQOjVZfYtlx3Q__&Key-Pair-Id=APKAJT6QIWSKVYK3V34A", imageName: "israelim"),
                Episode(episodeNumber: 7, name: "הישראלים, עונה 1, פרק 7", streamURL: "https://cfvod.kaltura.com/scf/enc/hls/p/2748741/sp/274874100/serveFlavor/entryId/1_tykzc499/v/31/ev/18/flavorId/1_6juqc8hu/name/a.mp4/index.m3u8?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZnZvZC5rYWx0dXJhLmNvbS9zY2YvZW5jL2hscy9wLzI3NDg3NDEvc3AvMjc0ODc0MTAwL3NlcnZlRmxhdm9yL2VudHJ5SWQvMV90eWt6YzQ5OS92LyoiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE3NjE1MDU5NDF9fX1dfQ__&Signature=F~O-7wgA~etTMtHadYginvcWz60lqSqqqeKli4cCn66e8rNj-hGMXqN17eG0bRiBVTiwfjwO53qsYYqXdjxDphoyP71lqm8Mp~u6lnl8TgUqTOX8w5dhi7Vohl8HL2xYsHjHL97239fNCb4JYGKMr9MNxrJxYIBSbxG-b2NGptJ~omVdOFyw3bXPXtX2Ne~NE53Bcu1P7mdUL9qKtZfn1Sbhtga~dFZm2At62luAf70xqgOnKsgMJTpVldCpskJ7X1ry6HUcPdEixPAZB6p1-P7Id3DRsuUQMq~TbkI~QFwTfQDt0K5Zk3CIfByblOSHZzInYuxyRzacy9YYHd9QHw__&Key-Pair-Id=APKAJT6QIWSKVYK3V34A", imageName: "israelim"),
                Episode(episodeNumber: 8, name: "הישראלים, עונה 1, פרק 8", streamURL: "https://cfvod.kaltura.com/scf/enc/hls/p/2748741/sp/274874100/serveFlavor/entryId/1_pqryiw78/v/31/ev/18/flavorId/1_h171yqg6/name/a.mp4/index.m3u8?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZnZvZC5rYWx0dXJhLmNvbS9zY2YvZW5jL2hscy9wLzI3NDg3NDEvc3AvMjc0ODc0MTAwL3NlcnZlRmxhdm9yL2VudHJ5SWQvMV9wcXJ5aXc3OC92LyoiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE3NjE1MDU5OTB9fX1dfQ__&Signature=VYFW5eXDpnnEa8ICyn7H6Ad726fhty7ypsKUlKsjfnTevy06d-y79c8doxopIcr1z8ZAd2PF5~UvxO1QE7xbhOu9Zck9IZ3mU8atHPtb16jGtjM-zI1JUEfe3v889~qSYIGSKGTElUzYbwnX-z9L8GjHxcE6645ipoqJ9Xjv8LCs5BRoI9uGcPYLlTPD4jUvuuTrk5BtrsP5QzTs27vfwGwMTjYOgTOUeX6fAdIcNC7aoVIeHqHCYMALmLDAux3YaEvIPHFSMSN4lo2~ZF9BWF4yJC9tpIarQQ3xIQZdUeH4jMbyIbs9UBcVmDw1iUjrEun2iN3rJEruBp-LxKo45Q__&Key-Pair-Id=APKAJT6QIWSKVYK3V34A", imageName: "israelim"),
            ]
        )
    ]
    
    var filteredSeries: [Series] {
        if searchText.isEmpty {
            return series
        } else {
            return series.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.backgroundPrimary.ignoresSafeArea()
                
                List {
                    if filteredSeries.isEmpty && !searchText.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            
                            Text("No results found")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Text("Try adjusting your search")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(40)
                        .frame(maxWidth: .infinity)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                    }
                    
                    ForEach(filteredSeries) { seriesItem in
                        ZStack {
                            NavigationLink(destination: SeriesDetailView(series: seriesItem)) {
                                EmptyView()
                            }
                            .opacity(0)
                            
                            HStack(spacing: 16) {
                                // Series logo/image
                                if let imageName = seriesItem.imageName {
                                    Image(imageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(8)
                                } else {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(LinearGradient(
                                                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ))
                                            .frame(width: 60, height: 60)
                                        
                                        Image(systemName: "tv.fill")
                                            .foregroundColor(.white)
                                            .font(.title2)
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(seriesItem.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Text("\(seriesItem.episodes.count) episodes")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                                    .font(.body)
                            }
                            .padding(16)
                            .background(themeManager.cardBackground)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    }
                    .onMove(perform: moveSeries)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Shows")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search shows")
            .onAppear {
                loadSeries()
            }
        }
    }
    
    private func loadSeries() {
        if let savedData = UserDefaults.standard.data(forKey: "showsSeriesOrder"),
           let savedSeries = try? JSONDecoder().decode([Series].self, from: savedData) {
            series = savedSeries
        } else {
            series = defaultSeries
        }
    }
    
    private func saveSeries() {
        if let encoded = try? JSONEncoder().encode(series) {
            UserDefaults.standard.set(encoded, forKey: "showsSeriesOrder")
        }
    }
    
    private func moveSeries(from source: IndexSet, to destination: Int) {
        series.move(fromOffsets: source, toOffset: destination)
        saveSeries()
    }
}

#Preview {
    ShowsView()
}
