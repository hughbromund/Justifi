const path = require("path");
const got = require("got");
const config = require(path.resolve(__dirname, "../config.json"));

exports.getNextVideoStub = async function (req) {
    return {
        url: 'test download url'
    }
}

exports.getUploadVideoStub = async function (req) {
    return {
        url: 'test upload url'
    }
}


exports.getNextVideo = async function (req) {
    const result = await got.get('https://api.cloudflare.com/client/v4/accounts/a99b0a7df611e3bb46d42f2ed68add62/stream/763125bad164e2c7162aa877d1f0b3f8', {
        headers: {"Authorization" : "Bearer " + config.token,
        },
        responseType: 'json',
        resolveBodyOnly: true
    })
    console.log(result)
    return {
        url: result.result.playback.hls
    }
}