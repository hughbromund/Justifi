const express = require("express");
const path = require("path");
const router = express.Router();

const authJwt = require(path.resolve(
    __dirname,
    "../Middlewares/AuthJwt"
))

const verifySignUp = require(path.resolve(
    __dirname,
    "../Middlewares/VerifySignUp"
))

const videoController = require(path.resolve(
    __dirname,
    "../Controllers/VideoController"
))

const userController = require(path.resolve(
    __dirname,
    "../Controllers/UserController"
))

router.post("api/video/calclist", authJwt.verifyToken, )
router.get("/api/video/list", authJwt.verifyToken, videoController.getNextVideo);
router.get("/api/video/response/:prevpostuid", authJwt.verifyToken, videoController.getResponseVideo);

router.get("/api/video/uploadURL", authJwt.verifyToken, videoController.uploadVideoURL);
router.post("/api/video/uploadData", authJwt.verifyToken, videoController.uploadVideoData)

router.post("/api/auth/signup", verifySignUp.checkDuplicateUsername, userController.signup);
router.post("/api/auth/login", userController.login);

module.exports = router;