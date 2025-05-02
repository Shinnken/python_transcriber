# Python Transcriber

Python Transcriber is a free and easy-to-use tool for transcribing audio files into text using the [Vosk](https://alphacephei.com/vosk/) speech recognition library. It supports multiple audio formats, including `.wav`, `.mp3`, `.flac`, and `.m4a`.

## Features
- Supports transcription of `.wav`, `.mp3`, `.flac`, and `.m4a` files.
- Converts audio to mono PCM format with a sample rate of 16 kHz for optimal transcription.
- Saves transcriptions as `.txt` files with UTF-8 encoding.
- User-friendly graphical interface built with `customtkinter`.

## Prerequisites
- Python 3.7 or higher
- [FFmpeg](https://ffmpeg.org/download.html) installed and added to your system's PATH.

### Installing FFmpeg
If you don't have FFmpeg installed, you can use the `ffmpeg_install.sh` script to install it automatically. This script is designed to work with Git Bash or a similar terminal on Windows.

1. Open Git Bash or a compatible terminal.
2. Navigate to the project directory:
   ```bash
   cd c:/Users/konra/Documents/git/python_transcriber
   ```
3. Run the script:
   ```bash
   bash ffmpeg_install.sh
   ```
4. Follow the on-screen instructions to complete the installation.

After installation, verify FFmpeg is installed by running:
```bash
ffmpeg -version
```

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/python_transcriber.git
   cd python_transcriber
   ```

2. Install the required Python packages:
   ```bash
   pip install -r requirements.txt
   ```

3. Download the Vosk model:
   - Visit [Vosk Models](https://alphacephei.com/vosk/models) and download a suitable model for your language.
   - Extract the model and place it in the `SRC/vosk-model` directory.

## Usage
1. Run the application:
   ```bash
   python SRC/UI.py
   ```

2. Use the graphical interface to:
   - Select an audio file (`.wav`, `.mp3`, `.flac`, `.m4a`).
   - Transcribe the audio and save the transcription as a `.txt` file.

## Troubleshooting
- **FFmpeg not found**: Ensure FFmpeg is installed and added to your system's PATH. Use the `ffmpeg_install.sh` script if needed.
- **Vosk model not found**: Ensure the Vosk model is downloaded and placed in the `SRC/vosk-model` directory.
- **Encoding errors**: Transcriptions are saved with UTF-8 encoding to handle special characters. Ensure your text editor supports UTF-8.

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.

## Acknowledgments
- [Vosk Speech Recognition](https://alphacephei.com/vosk/)
- [FFmpeg](https://ffmpeg.org/)
- [CustomTkinter](https://github.com/TomSchimansky/CustomTkinter)
