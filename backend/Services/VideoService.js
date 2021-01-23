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


exports.getNextVideo = async function (req) {
    let user = await Users.findOne({username: req.userId})
    //let videos = await Videos.find({"uid" : { "$in" : user.feed}})

    var query = [
        {$match: {uid: {$in: user.feed}}},
        {$addFields: {"__order": {$indexOfArray: [user.feed, "$uid" ]}}},
        {$sort: {"__order": 1}}
       ];

    var result = await Videos.aggregate(query);

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
        list: result
    }
}

exports.getResponseVideo = async function (req) {
    let vid = await Videos.findOne({
        uid: req.params.prevpostuid
    })
    var query = [
        {$match: {uid: {$in: vid.responsesUID}}},
        {$addFields: {"__order": {$indexOfArray: [vid.responsesUID, "$uid" ]}}},
        {$sort: {"__order": 1}}
       ];

    var result = await Videos.aggregate(query);

    return {
        list: result
    }

}

exports.getUploadVideoURL = async function (req) {
    const result = await got.post('https://api.cloudflare.com/client/v4/accounts/a99b0a7df611e3bb46d42f2ed68add62/stream/direct_upload', {
        headers: {"Authorization" : "Bearer " + config.token,
        },
        json: {
            "maxDurationSeconds": 60
        },
        responseType: 'json',
        resolveBodyOnly: true
    })

    return result;
}

exports.uploadVideoData = async function (req) {
    const {uid, url, thumbnail, title, username, isOriginal, origUID} = req.body
    const video = new Videos({
        uid: uid,
        url: url,
        thumbnail: thumbnail,
        title: title,
        date: new Date(Date.now()).toISOString(),
        upvotes: 1,
        username: username,
        isOriginal: isOriginal,
        responsesUID: []
    })

    user.save((err, user) => {
        if (err) {
          //res.status(500).send({ message: err });
          return;
        }
        //res.send({ message: "User was registered successfully!" });
      });
    
    if (!isOriginal) {
        Videos.updateOne({
            uid: origUID
        },
        {
            "$push": {responsesUID: uid}
        })
    }

    return { message: "Video information saved successfully!" };
}