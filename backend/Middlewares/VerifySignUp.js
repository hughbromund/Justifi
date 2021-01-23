const path = require("path");
const Users = require(path.resolve(__dirname, "../Database/Models/Users"));

checkDuplicateUsername = (req, res, next) => {
  // Username
  Users.findOne({
    username: req.body.username
  }).exec((err, user) => {
    if (err) {
      res.status(500).send({ message: err });
      return;
    }

    if (user) {
      res.status(400).send({ message: "Failed! Username is already in use!" });
      return;
    }
  });
  next();
};


const verifySignUp = {
  checkDuplicateUsername,
};

module.exports = verifySignUp;
