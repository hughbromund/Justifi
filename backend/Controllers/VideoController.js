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
    let result = await VideoService.getResponseVideo(req);
    res.status(200).json(result);
}

exports.uploadVideoURL = async function (req, res, next) {
    let result = await VideoService.getUploadVideoURL(req);
    res.status(200).json(result);
}

exports.uploadVideoData = async function (req, res, next) {
    let result = await VideoService.uploadVideoData(req);
    res.status(200).json(result);
}

exports.likeVideo = async function (req, res, next) {
    let result = await VideoService.likeVideo(req);
    res.status(200).json(result);
}

exports.unlikeVideo = async function (req, res, next) {
    let result = await VideoService.unlikeVideo(req);
    res.status(200).json(result);
}