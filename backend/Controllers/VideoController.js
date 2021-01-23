const path = require("path");

var VideoService = require(path.resolve(
    __dirname,
    "../Services/VideoService.js"
))

exports.getNextVideo = async function (req, res, next) {
    let result = await VideoService.getNextVideoStub(req);
    res.status(result.status).json(result);
}

exports.uploadVideo = async function (req, res, next) {
    let result = await VideoService.uploadVideoStub(req);
    res.status(result.status).json(result);
}