const path = require("path");

var VideoService = require(path.resolve(
    __dirname,
    "../Services/VideoService.js"
))

exports.getNextVideo = async function (req, res, next) {
    let result = await VideoService.getNextVideo(req);
    res.status(200).json(result);
}

exports.getResponseVideo = async function (req, res, next) {
    let result = await VideoService.getResponseVideoStub(req);
    res.status(200).json(result);
}

exports.uploadVideo = async function (req, res, next) {
    let result = await VideoService.uploadVideoStub(req);
    res.status(200).json(result);
}