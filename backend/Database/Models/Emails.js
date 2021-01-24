const mongoose = require('mongoose')
const Schema = mongoose.Schema
mongoose.promise = Promise

// Define userSchema
const emailsSchema = new Schema({
    email: { type: String, unique: true, required: true},
    first: { type: String, unique: false, required: true},
    last: { type: String, unique: false, required: true},
}, { collection: "Emails"})

// Define schema methods
emailsSchema.methods = {}


const Emails = mongoose.model('Emails', emailsSchema)
module.exports = Emails