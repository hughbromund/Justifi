const path = require("path");


var UserService = require(path.resolve(
    __dirname,
    "../Services/UserService.js"
))

exports.signup = async function (req, res, next) {
    UserService.signup(req, res);
    //res.status(200).json(result);
}

exports.login = async function (req, res, next) {
    UserService.login(req, res);
    //res.status(200).json(result);
}