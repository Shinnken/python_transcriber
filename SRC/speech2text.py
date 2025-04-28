from vosk import Model, KaldiRecognizer
import wave
from pydub import AudioSegment  # Import AudioSegment for file conversion
import os
import sys

def transcribe_audio(file_path):
    """
    Transcribe audio from a file using the Vosk library.
    
    Args:
        file_path (str): Path to the audio file.
    
    Returns:
        str: Transcribed text.
    """
    original_file_path = file_path  # Keep track of the original file path

    # Convert to .wav if necessary
    if not file_path.endswith(".wav"):
        audio = AudioSegment.from_file(file_path)
        file_path = file_path.rsplit(".", 1)[0] + ".wav"
        audio.export(file_path, format="wav")
    
    # Ensure the audio file is mono PCM with a sample rate of 16000 Hz
    audio = AudioSegment.from_file(file_path)
    if audio.channels != 1 or audio.frame_rate != 16000:
        audio = audio.set_channels(1).set_frame_rate(16000)
        file_path = file_path.rsplit(".", 1)[0] + "_converted.wav"
        audio.export(file_path, format="wav")

    try:
        # Resolve the model path dynamically
        if getattr(sys, 'frozen', False):  # If running as a compiled executable
            base_path = sys._MEIPASS
        else:  # If running as a script
            base_path = os.path.dirname(__file__)
        model_path = os.path.join(base_path, "vosk-model")

        if not os.path.exists(model_path):
            return "Vosk model not found. Please download and place it in the 'vosk-model' directory."

        model = Model(model_path)
        recognizer = KaldiRecognizer(model, 16000)

        # Open the audio file
        with wave.open(file_path, "rb") as wf:
            transcription = []
            while True:
                data = wf.readframes(4000)
                if len(data) == 0:
                    break
                if recognizer.AcceptWaveform(data):
                    result = recognizer.Result()
                    transcription.append(result)
            
            # Get the final transcription
            final_result = recognizer.FinalResult()
            transcription.append(final_result)

        # Combine all results into a single string
        return " ".join([eval(res)["text"] for res in transcription if "text" in eval(res)])
    finally:
        # Clean up temporary .wav file if it was created
        if file_path != original_file_path and os.path.exists(file_path):
            os.remove(file_path)

if __name__ == "__main__":
    # Example usage
    file_path = "path/to/your/audio/file.mp3"  # Can now handle .mp3 and .m4a
    transcription = transcribe_audio(file_path)
    print("Transcription:", transcription)