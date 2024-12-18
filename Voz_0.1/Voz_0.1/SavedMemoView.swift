//
//  SavedMemoView.swift
//  Voz
//
//  Created by Eugenio Lozano on 12/12/24.
//

import SwiftUI

struct SavedMemoView: View {
    @ObservedObject var memoManager = MemoManager()
    let audioManager = AudioManager()
    
    var body: some View {
        NavigationView{
            List {
                ForEach(memoManager.memos) { memo in
                    HStack{
                        VStack(alignment: .leading){
                            Text("Recorded on:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(formattedDate(memo.date))
                                .fontWeight(.medium)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            playMemo(fileName: memo.fileName)
                        }) {
                            Image(systemName: "play.circle")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("Saved Memos")
        }
    }
    
    func playMemo(fileName: String) {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentPath.appendingPathComponent(fileName)
        
        // Check if the file exists
        if FileManager.default.fileExists(atPath: fileURL.path) {
            print("File exists: \(fileURL.path)")
            audioManager.playRecording(url: fileURL)
        } else {
            print("Error: File does not exist at \(fileURL.path)")
        }
    }

    
    func formattedDate(_ date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
        
    }}

#Preview {
    SavedMemoView()
}
