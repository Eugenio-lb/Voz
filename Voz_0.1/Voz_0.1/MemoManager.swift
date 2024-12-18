//
//  MemoManager.swift
//  Voz
//
//  Created by Eugenio Lozano on 16/12/24.
//

import Foundation

struct DailyMemo: Identifiable, Codable{
    let id: UUID
    let date: Date
    let fileName: String
    init(date: Date, fileName: String){
        self.id = UUID()
        self.date = date
        self.fileName = fileName
    }
}

class MemoManager: ObservableObject{
    @Published var memos: [DailyMemo] = []
    
    private let memosKey = "dailyMemos"
    
    init() {
        loadMemos()
    }
    func addMemo(date: Date, fileName: String){
        let newMemo = DailyMemo(date: date, fileName: fileName)
        memos.append(newMemo)
        saveMemos()
    }
    
    func saveMemos(){
        if let encoded = try? JSONEncoder().encode(memos){
            UserDefaults.standard.set(encoded, forKey: memosKey)
        }
    }
    func loadMemos(){
        if let savedData = UserDefaults.standard.data(forKey: memosKey),
           let decoded = try? JSONDecoder().decode([DailyMemo].self, from: savedData) {
            memos = decoded
        }
    }
}
