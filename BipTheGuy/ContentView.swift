//
//  ContentView.swift
//  BipTheGuy
//
//  Created by Tushar Munge on 6/13/25.
//

import AVFAudio
import PhotosUI
import SwiftUI

struct ContentView: View {
    @State private var audioPlayer: AVAudioPlayer!
    @State private var isFullSize = true
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var bipImage = Image("clown")

    var body: some View {
        VStack {
            Spacer()

            bipImage
                .resizable()
                .scaledToFit()
                .scaleEffect(isFullSize ? 1.0 : 0.9)
                .onTapGesture {
                    playSound(soundName: "punchSound")

                    // This will immediately shrink using .scaleEffect() above
                    // to 90% of size
                    isFullSize = false

                    withAnimation(.spring(response: 0.3, dampingFraction: 0.3))
                    {
                        // This will immediately grow from 90% to 100% size
                        // using the .spring() animation
                        isFullSize = true
                    }
                }

            Spacer()

            PhotosPicker(
                selection: $selectedPhoto,
                matching: .images,
                preferredItemEncoding: .automatic
            ) {
                Label(
                    "Photo Library",
                    systemImage: "photo.fill.on.rectangle.fill"
                )
            }
            .onChange(of: selectedPhoto) {
                Task
                {
                    guard let selectedImage = try? await selectedPhoto?.loadTransferable(type: Image.self) else {
                        print("😡 ERROR: Could not load selected photo")
                        
                        return
                    }
                    
                    bipImage = selectedImage
                }
            }
        }
        .padding()
    }

    func playSound(soundName: String) {
        // Prior to playing a sound, check if it's already playing one.
        // If it is, stop it. This prevents overlapping sounds from
        // playing.
        if audioPlayer != nil && audioPlayer.isPlaying {
            audioPlayer.stop()
        }

        //TODO: - Get the Sound file -
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 Could not read file named \(soundName)")

            return
        }

        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print(
                "😡 ERROR: \(error.localizedDescription) creating audioPlayer"
            )
        }
    }
}

#Preview {
    ContentView()
}
