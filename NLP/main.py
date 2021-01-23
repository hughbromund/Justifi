from google.cloud import speech
import io
import json
from googleapiclient import discovery
import config
import os
import wave
import subprocess


def is_toxic(video_url):
    """Transcribe the given audio file."""

    # Pull audio from video
    command = "ffmpeg -y -i " + video_url + \
        " -ab 160k -ac 2 -ar 44100 -vn new_audio.wav"
    subprocess.call(command, shell=True)
    client = speech.SpeechClient()
    speech_file = "new_audio.wav"

    # Open file and parse content and frame rate
    with io.open(speech_file, "rb") as audio_file:
        content = audio_file.read()
    with wave.open(speech_file, "rb") as wave_file:
        frame_rate = wave_file.getframerate()

    # Configuration for Google Cloud speech-to-text
    audio = speech.RecognitionAudio(content=content)
    speech_config = speech.RecognitionConfig(
        encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
        sample_rate_hertz=frame_rate,
        language_code="en-US",
        audio_channel_count=2,
    )

    response = client.recognize(config=speech_config, audio=audio)

    full_transcript = ""

    # Loop through statements
    for result in response.results:
        # Concatenate to full transcript
        full_transcript = full_transcript + \
            result.alternatives[0].transcript + "."

    print("TRANSCRIPT: {}".format(full_transcript))

    """ TOXICITY ANALYSIS """

    API_KEY = config.perspective_api_key

    # Generates API client object dynamically based on service name and version.
    service = discovery.build(
        'commentanalyzer', 'v1alpha1', developerKey=API_KEY)

    analyze_request = {
        'comment': {'text': full_transcript},
        'requestedAttributes': {'TOXICITY': {}}
    }

    response = service.comments().analyze(body=analyze_request).execute()

    if response["attributeScores"]["TOXICITY"]["summaryScore"]["value"] > 0.6:
        return {"is_toxic": True}

    return {"is_toxic": False}


def post_toxicity(request):

    request_json = request.get_json(silent=True)
    request_args = request.args

    if request_json and 'url' in request_json:
        url = request_json['url']
    elif request_args and 'url' in request_args:
        url = request_args['url']
    else:
        url = "https://videodelivery.net/e0498bfcecf870a1567b4c667d89b4e0/manifest/video.m3u8"

    return is_toxic(video_url=url)
