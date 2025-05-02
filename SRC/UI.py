import customtkinter as ctk
from tkinter import filedialog, messagebox
import os
from speech2text import transcribe_audio
import threading
import sys

class TranscriberApp(ctk.CTk):
    def __init__(self):
        super().__init__()
        self.title("Audio Transcriber")
        self.geometry("400x250")  # Adjusted height to accommodate the progress bar

        self.file_path = None

        # Pick File Button
        self.pick_file_button = ctk.CTkButton(self, text="Pick Audio File", command=self.pick_file)
        self.pick_file_button.pack(pady=20)

        # Transcribe Button
        self.transcribe_button = ctk.CTkButton(self, text="Transcribe and Save", command=self.transcribe_and_save)
        self.transcribe_button.pack(pady=20)

        # Progress Bar
        self.progress_bar = ctk.CTkProgressBar(self, mode="indeterminate")
        self.progress_bar.pack(pady=20)
        self.progress_bar.set(0)  # Initially set to 0

    def pick_file(self):
        file_path = filedialog.askopenfilename(filetypes=[("Audio Files", "*.wav *.mp3 *.flac *.m4a")])
        if file_path:
            if self.is_audio_file(file_path):
                self.file_path = file_path
                messagebox.showinfo("File Selected", f"Selected: {os.path.basename(file_path)}")
            else:
                messagebox.showerror("Invalid File", "Please select a valid audio file.")

    def is_audio_file(self, file_path):
        return file_path.lower().endswith(('.wav', '.mp3', '.flac', '.m4a'))

    def transcribe_and_save(self):
        if not self.file_path:
            messagebox.showerror("No File Selected", "Please select an audio file first.")
            return

        # Start the progress bar animation
        self.progress_bar.start()

        # Run transcription in a separate thread
        threading.Thread(target=self._transcribe_and_save_worker, daemon=True).start()

    def _transcribe_and_save_worker(self):
        try:
            transcription = transcribe_audio(self.file_path)
            if transcription:
                save_path = filedialog.asksaveasfilename(defaultextension=".txt", filetypes=[("Text Files", "*.txt")])
                if save_path:
                    with open(save_path, "w", encoding="utf-8") as file:
                        file.write(transcription)
                    messagebox.showinfo("Success", f"Transcription saved to {save_path}")
            else:
                messagebox.showerror("Error", "Failed to transcribe the audio file.")
        except Exception as e:
            # Capture the traceback and print it to stderr
            import traceback
            print(f"Error during transcription: {e}", traceback.format_exc(), file=sys.stderr)  # Corrected to use format_exc()
            # Show error message to the user
            messagebox.showerror("Error", f"An error occurred: {e}")

        finally:
            # Stop the progress bar animation
            self.progress_bar.stop()
            self.progress_bar.set(0)  # Reset progress bar

if __name__ == "__main__":
    app = TranscriberApp()
    app.mainloop()