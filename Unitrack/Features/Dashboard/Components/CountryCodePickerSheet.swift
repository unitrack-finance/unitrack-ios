//
//  CountryCodePickerSheet.swift
//  Unitrack
//

import SwiftUI

struct CountryCodePickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCountry: CountryCode
    @State private var searchText = ""
    
    var filteredCountries: [CountryCode] {
        if searchText.isEmpty {
            return CountryCode.samples
        } else {
            return CountryCode.samples.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.code.contains(searchText) }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Grabber handle is provided by presentationDragIndicator
            
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.textSecondary)
                
                TextField("Search", text: $searchText)
                    .customFont(.body)
            }
            .padding()
            .background(Color.cardBackgroundSecondary, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .padding()
            
            // Country List
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(filteredCountries) { country in
                        Button(action: {
                            selectedCountry = country
                            dismiss()
                        }) {
                            HStack(spacing: 16) {
                                Text(country.flag)
                                    .font(.title3)
                                
                                Text(country.code)
                                    .customFont(.headline)
                                    .foregroundStyle(Color.textPrimary)
                                
                                Text(country.name)
                                    .customFont(.body)
                                    .foregroundStyle(Color.textPrimary)
                                
                                Spacer()
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 24)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        
                        Divider()
                            .padding(.leading, 64)
                            .opacity(0.1)
                    }
                }
            }
        }
        .background(Color.screenBackground)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    CountryCodePickerSheet(selectedCountry: .constant(CountryCode.samples[0]))
        .preferredColorScheme(.dark)
}
