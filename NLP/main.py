from google.cloud import language_v1
from google.cloud import speech
import io
import json
from googleapiclient import discovery
import config
import os
import wave
import subprocess
import argparse
from pymongo import MongoClient


def get_vid_cat(video_url, id):
    """ Mongo stuff """

    client = MongoClient(config.mongo_url)
    db = client["Justifi-Database"]
    mycol = db["Videos"]

    """Transcribe the given audio file."""

    # Pull audio from video
    command = "ffmpeg -y -i " + video_url + \
        " -ab 160k -ac 2 -ar 44100 -vn ./new_audio.wav"
    subprocess.call(command, shell=True)
    client = speech.SpeechClient()
    speech_file = "./new_audio.wav"

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

    """Classify the input text into categories. """

    language_client = language_v1.LanguageServiceClient()

    text = full_transcript
    document = language_v1.Document(
        content=text, type_=language_v1.Document.Type.PLAIN_TEXT
    )
    try:
        response = language_client.classify_text(
            request={'document': document})
    except:
        print("NOT ENOUGH TOKENS!!")
        return {"category": "None"}
    categories = response.categories

    result = {}

    for category in categories:
        # Turn the categories into a dictionary of the form:
        # {category.name: category.confidence}, so that they can
        # be treated as a sparse vector.
        result[category.name] = category.confidence

    tag_to_store = ""
    for x in result:
        x = x[1:]
        x = x.lower()
        first_slash = x.find("/")
        if first_slash != -1:
            x = x[:first_slash]
        x = x.replace("&", "and")
        x = x.replace(" ", "_")
        tag_to_store = x
        break

    mycol.update_one({
        'uid': id
    }, {
        '$set': {
            'tag': tag_to_store
        }
    }, upsert=False)

    print(result)
    return result


def post_categorize(request):

    request_json = request.get_json(silent=True)
    request_args = request.args

    if request_json and 'url' in request_json:
        url = request_json['url']
    elif request_args and 'url' in request_args:
        url = request_args['url']
    else:
        url = "https://videodelivery.net/1373d5002893cfb3c92e3608d23125f6/manifest/video.m3u8"

    if request_json and 'uid' in request_json:
        uid = request_json['uid']
    elif request_args and 'uid' in request_args:
        uid = request_args['uid']
    else:
        uid = "1373d5002893cfb3c92e3608d23125f6"

    return get_vid_cat(video_url=url, id=uid)

# get_vid_cat(video_url="https://videodelivery.net/1373d5002893cfb3c92e3608d23125f6/manifest/video.m3u8",
#             id="1373d5002893cfb3c92e3608d23125f6")
