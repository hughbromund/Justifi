const mongoose = require('mongoose')
const Schema = mongoose.Schema
mongoose.promise = Promise

// Define userSchema
const usersSchema = new Schema({
    username: { type: String, unique: true, required: true},
    password: { type: String, unique: false, required: true},
}, { collection: "Users"})

// Define schema methods
budgetSchema.methods = {}


const Users = mongoose.model('Users', usersSchema)
module.exports = Users