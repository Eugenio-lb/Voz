import SwiftUI

struct ContentView: View {
    let audioManager = AudioManager()
    let dailyQuestionManager = DailyQuestionManager()
    
    
    @State private var isRecording = false
    @StateObject var memoManager = MemoManager()
    @State private var currentFileName: String?
    
    
    var body: some View {
        VStack(spacing: 20) {
            Text(dailyQuestionManager.dailyQuestion)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 25)
            
            if dailyQuestionManager.hasAnsweredToday(){
                Text("You have already answered today's question.")
                    .foregroundColor(.red)
                    .padding()
            }else {
                
                Button(action: {
                    if isRecording {
                        audioManager.stopRecording()
                        dailyQuestionManager.markAsAnswered()
                        
                        if let fileName = currentFileName {
                            memoManager.addMemo(date: Date(), fileName: fileName)
                            currentFileName = nil
                        }
                    } else {
                        let fileName = createUniqueFileName()
                        currentFileName = fileName
                        audioManager.startRecording(fileName: fileName)
                    }
                    isRecording.toggle()
                }) {
                    ZStack{
                        Circle()
                            .foregroundStyle(Color.black)
                            .frame(width: 302)
                    
                        Circle()
                            .foregroundStyle(isRecording ? Color.black : Color.white)
                            .frame(width: 300)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { _ in
                                        if !isRecording {
                                            isRecording = true
                                            let fileName = createUniqueFileName()
                                            currentFileName = fileName
                                            audioManager.startRecording(fileName: fileName)
                                        }
                                    }
                                    .onEnded { _ in
                                        if isRecording {
                                            isRecording = false
                                            audioManager.stopRecording()
                                            dailyQuestionManager.markAsAnswered()
                                            
                                            if let fileName = currentFileName {
                                                memoManager.addMemo(date: Date(), fileName: fileName)
                                                currentFileName = nil
                                            }
                                        }
                                    }
                            )
                        
                        Text(isRecording ? "Stop" : "Hold to answer")
                            .padding()
                            .foregroundColor(isRecording ? .white : .black)

                    }
                }
                
            }
            
        }
        .padding()
    }
}

func createUniqueFileName() -> String{
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd_HHmmss"
    let dateString = formatter.string(from: Date())
    return "voiceMemo_\(dateString).m4a"
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
