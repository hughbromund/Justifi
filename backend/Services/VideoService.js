const path = require("path");
const got = require("got");
const { user } = require("../Database");
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
    let user = await Users.findOne({_id: req.userId})
    //let videos = await Videos.find({"uid" : { "$in" : user.feed}})

    var query = [
        {$match: {uid: {$in: user.feed}}},
        {$addFields: {"__order": {$indexOfArray: [user.feed, "$uid" ]}}},
        {$sort: {"__order": 1}}
       ];

    var result = await Videos.aggregate(query);

    

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
    const {uid, title, isOriginal, origUID} = req.body

    let url = "https://videodelivery.net/" + uid + "/manifest/video.m3u8";
    let thumbnail = "https://videodelivery.net/" + uid + "/thumbnails/thumbnail.jpg";

    let user = await Users.findOne({_id: req.userId})
    const video = new Videos({
        uid: uid,
        url: url,
        thumbnail: thumbnail,
        title: title,
        date: new Date(Date.now()).toISOString(),
        upvotes: 1,
        username: user.username,
        isOriginal: isOriginal,
        responsesUID: []
    })
    

    video.save((err, user) => {
        if (err) {
          //res.status(500).send({ message: err });
          return;
        }
        //res.send({ message: "User was registered successfully!" });
      });
    
    if (!isOriginal) {
        let temp_res = await Videos.updateOne({
            uid: origUID
        },
        {
            "$push": {responsesUID: uid}
        })
    }

    const categorizeResult = await got.post('https://us-central1-jusifi.cloudfunctions.net/post_categorize', {
        json: {
            "uid": uid,
            "url": url
        },
        responseType: 'json',
        resolveBodyOnly: true
    })

    const toxicResult = await got.post('https://us-central1-jusifi.cloudfunctions.net/post_toxicity', {
        json: {
            "uid": uid,
            "url": url
        },
        responseType: 'json',
        resolveBodyOnly: true
    })

    return { message: "Video information saved successfully!" };
}

exports.likeVideo = async function (req) {
    const {uid} = req.body;
    let video = await Videos.findOne({uid: uid})
    let user = await Users.findOne({_id: req.userId})
    let category = "interests." + video.tag

    let userUpdate = await Users.updateOne({username: user.username}, {"$inc": {numUpvotes: 1, [category]: 1}})
    let vidUpdate = await Videos.updateOne({uid: uid}, {"$inc": {upvotes: 1}, "$push": {likedUsers: user.username}})

    return { message: "Upvote Successful"};
}

exports.unlikeVideo = async function (req) {
    const {uid} = req.body;
    let video = await Videos.findOne({uid: uid})
    let user = await Users.findOne({_id: req.userId})
    let category = "interests." + video.tag

    let userUpdate = await Users.updateOne({username: user.username}, {"$inc": {numUpvotes: -1, [category]: -1}})
    let vidUpdate = await Videos.updateOne({uid: uid}, {"$inc": {upvotes: -1}, "$pull": {likedUsers: user.username}})

    return { message: "Upvote Successful"};
}

exports.calculateVideoList = async function (req) {
    let user = await Users.findOne({_id: req.userId})

    let date = new Date();
    date.setDate(date.getDay() - 1)

    let videoList = await Videos.find({date: { "$gte" : date}, isViewable: true, isOriginal: true})

    for (var i = 0; i < videoList.length; i++) {
        var score = videoList[i].upvotes * (user.interests[videoList[i].tag] / (user.numUpvotes + 28));
        videoList[i].score = score;
    }
    
    //create score for each

    videoList.sort((a, b) => (a.score > b.score) ? 1 : -1)

    let finalList = []
    for (var i = 0; i < videoList.length; i++) {
        finalList.push(videoList[i].uid)
    }
    console.log(finalList)

    let result = await Users.updateOne({_id: req.userId}, {feed: finalList})

    return { message: "Feed Calculation Complete"}
}

exports.hasLiked = async function (req) {
    let user = await Users.findOne({_id: req.userId})
    let video = await Videos.findOne({uid: req.params.uid})

    var hasLiked = video.likedUsers.includes(user.username);

    return { "hasLiked": hasLiked}
}

