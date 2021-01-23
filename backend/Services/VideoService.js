
const path = require("path");


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