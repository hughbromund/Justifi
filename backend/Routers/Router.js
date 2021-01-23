const express = require("express");
const path = require("path");
const router = express.Router();

const videoController = require(path.resolve(
    __dirname,
    "../Controllers/VideoController"
))

router.get("/api/nextvideo", videoController.getNextVideo);
router.get("/api/uploadvideo", videoController.uploadVideo);

module.exports = router;