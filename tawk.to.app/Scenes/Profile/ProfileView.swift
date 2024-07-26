//
//  ProfileView.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 24/07/2024.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        cancel
        ZStack(alignment: .top) {
            if let url = URL(string: viewModel.userProfile.avatarURL) {
                makeBlurredAvatarBackground(url: url)
                HStack {
                    PillText(text: "Followers: \(viewModel.userProfile.followers)")
                        .padding(.leading, Size.base3)
                    Spacer()
                    PillText(text: "Following: \(viewModel.userProfile.following)")
                        .padding(.trailing, Size.base3)
                }
            }
            if let url = URL(string: viewModel.userProfile.avatarURL) {
                VStack(spacing: Size.base4) {
                    makeSmallAvatar(url: url)
                    Text(viewModel.userProfile.login)
                        .font(.poppinsBold(size: 18))
                    TitledText(title: "Company:", text: viewModel.userProfile.company ?? "-")
                    TitledText(title: "Email:", text: viewModel.userProfile.email ?? "-")
                    TitledText(title: "Blog:", text: viewModel.userProfile.blog ?? "-")
                    Spacer()
                }
                .padding(.horizontal, Size.base4)
            } else {
                VStack {
                    Image(.avatar)
                    Spacer()
                }
            }
        }
        .padding(.top, Size.base17)
        .onAppear {
            viewModel.fetchUserDetails()
        }
        .alert(isPresented: $viewModel.shouldShowError) {
            alert
        }
    }

    var cancel: some View {
        HStack(spacing: 0) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(.cancel)
                    .padding(.top, Size.base2)
                    .padding(.leading, Size.base2)
                    .foregroundColor(.black)
            }
            Spacer()
        }
    }

    var alert: Alert {
        Alert(
            title: Text("Error")
                .font(.poppinsSemiBold(size: 16)),
            message: Text("Could not fetch profile: \n\n\(viewModel.errorText)")
                .font(.poppins(size: 13)),
            dismissButton: .default(Text("OK")
                .font(.poppins(size: 14)))
        )
    }

    @ViewBuilder
    private func makeSmallAvatar(url: URL) -> some View {
        AsyncImage(url: url)
            .clipShape(RoundedRectangle(cornerRadius: Size.base3))
            .frame(width: Size.base17, height: Size.base17)
            .overlay(
                RoundedRectangle(cornerRadius: Size.base3)
                    .stroke(Color.white, lineWidth: Size.base0)
            )
            .padding(.top, Size.base4)
    }

    @ViewBuilder
    private func makeBlurredAvatarBackground(url: URL) -> some View {
        AsyncImage(url: url)
            .frame(height: Size.base20)
            .padding(.top, Size.base2)
            .clipped()
            .blur(radius: Size.base1)
    }
}
