//
//  AutomaticConnectionScreen.swift
//  Unitrack
//

import SwiftUI

struct AutomaticConnectionScreen: View {
    let institution: Institution
    @State private var phoneNumber = ""
    @State private var pin = ""
    @State private var selectedCountry: CountryCode = CountryCode.samples.first(where: { $0.code == "+385" }) ?? CountryCode.samples[0]
    @State private var showCountryPicker = false
    @State private var storeCredentials = false
    @State private var importCashBalances = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Visual Header (Reused from ImportOptions)
                VisualConnectionHeader(institution: institution)
                    .padding(.top, 40)
                
                VStack(spacing: 12) {
                    Text("Automatic connection")
                        .customFont(.title2)
                    
                    Text("Securely import your \(institution.name) account. All data is encrypted and stored on European servers. Your information remains within your control at all times.")
                        .customFont(.body)
                        .foregroundStyle(Color.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                // Form Fields
                VStack(spacing: 16) {
                    // Phone number input with country selector
                    HStack(spacing: 0) {
                        Button(action: { showCountryPicker = true }) {
                            HStack(spacing: 4) {
                                Text(selectedCountry.flag)
                                Text(selectedCountry.code)
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 12, weight: .bold))
                            }
                            .customFont(.headline)
                            .foregroundStyle(Color.textPrimary)
                            .padding(.horizontal, 12)
                            .frame(maxHeight: .infinity)
                            .background(Color.cardBackgroundSecondary.opacity(0.5))
                        }
                        
                        Divider()
                            .frame(height: 24)
                        
                        TextField("Phone number", text: $phoneNumber)
                            .keyboardType(.phonePad)
                            .customFont(.body)
                            .padding(.leading, 12)
                    }
                    .frame(height: 56)
                    .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    
                    // PIN/Password field
                    SecureField("****", text: $pin)
                        .customFont(.body)
                        .padding(.horizontal, 16)
                        .frame(height: 56)
                        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .padding(.horizontal, 20)
                
                // Checkboxes
                VStack(alignment: .leading, spacing: 20) {
                    CheckboxView(isOn: $storeCredentials, label: "Store credentials") {
                        // Info action
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Permissions")
                            .customFont(.headline)
                            .foregroundStyle(Color.textPrimary)
                        
                        CheckboxView(isOn: $importCashBalances, label: "Import my cash balances")
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer(minLength: 40)
                
                // Continue Button
                Button(action: {
                    // Finalize connection
                }) {
                    Text("Continue")
                        .customFont(.headline)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .background(Color.screenBackground)
        .navigationTitle(institution.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showCountryPicker) {
            CountryCodePickerSheet(selectedCountry: $selectedCountry)
        }
    }
}

struct CheckboxView: View {
    @Binding var isOn: Bool
    let label: String
    var infoAction: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: { isOn.toggle() }) {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.textTertiary, lineWidth: 2)
                    .frame(width: 24, height: 24)
                    .background(isOn ? Color.white : Color.clear, in: RoundedRectangle(cornerRadius: 4))
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.black)
                            .opacity(isOn ? 1 : 0)
                    )
            }
            .buttonStyle(.plain)
            
            Text(label)
                .customFont(.body)
                .foregroundStyle(Color.textPrimary)
            
            if let infoAction = infoAction {
                Button(action: infoAction) {
                    Image(systemName: "info.circle")
                        .foregroundStyle(Color.textTertiary)
                }
            }
            
            Spacer()
        }
    }
}

// Reusable Header Component
struct VisualConnectionHeader: View {
    let institution: Institution
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.cardBackgroundSecondary)
                .frame(width: 72, height: 72)
                .overlay(
                    Image(systemName: institution.logoName)
                        .font(.system(size: 28))
                )
            
            HStack(spacing: 4) {
                ForEach(0..<3) { _ in
                    Circle()
                        .fill(Color.textTertiary.opacity(0.3))
                        .frame(width: 4, height: 4)
                }
                Image(systemName: "chevron.right")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(Color.textTertiary.opacity(0.5))
            }
            
            Circle()
                .stroke(Color.textTertiary.opacity(0.5), lineWidth: 1)
                .frame(width: 72, height: 72)
                .overlay(
                    Text("g") // Placeholder for app icon
                        .font(.system(size: 32, design: .serif))
                )
        }
    }
}

#Preview {
    NavigationStack {
        AutomaticConnectionScreen(institution: Institution(name: "Trade Republic", logoName: "building.columns.fill", category: .popular))
            .preferredColorScheme(.dark)
    }
}
