const path = require("path");
const got = require("got");
const config = require(path.resolve(__dirname, "../config.json"));

const Videos = require(path.resolve(__dirname, "../Database/Models/Videos"));
const Users = require(path.resolve(__dirname, "../Database/Models/Users"));


exports.getNextVideoStub = async function (req) {
    return {
        url: 'test download url'
    }
}

exports.getResponseVideoStub = async function (req) {
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
    let user = await Users.findOne({username: req.params.username})
    let videos = Videos.find({"uid" : { "$in" : user.responsesUID}})

    console.log(user)
    console.log("-------------------------------")
    console.log(videos)
    

    /*
    const result = await got.get('https://api.cloudflare.com/client/v4/accounts/a99b0a7df611e3bb46d42f2ed68add62/stream/763125bad164e2c7162aa877d1f0b3f8', {
        headers: {"Authorization" : "Bearer " + config.token,
        },
        responseType: 'json',
        resolveBodyOnly: true
    })
    console.log(result)
    */

    return {
        list: videos
    }
}

exports.getResponseVideo = async function (req) {
    let vid = await Videos.findOne({
        uid: req.params.prevpostuid
    })
    return {
        list: vid.responsesUID
    }

}