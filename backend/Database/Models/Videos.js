const mongoose = require('mongoose')
const Schema = mongoose.Schema
mongoose.promise = Promise

// Define userSchema
const videosSchema = new Schema({
    uid: { type: String, unique: true, required: true},
    url: { type: String, unique: true, required: true},
    thumbnail: { type: String, unique: true, required: true},
    title: {type: String, unique: false, required: true},
    username: { type: String, unique: false, required: true},
    upvotes: { type: Number, default: 1, unique: false, required: true},
    date: {type: Date, unique: false, required: true},
    responsesUID: { type: Array, default: [], unique: false, required: true},
    isOriginal: { type: Boolean, default: true, unique: false, required: true},
}, { collection: "Videos"})

// Define schema methods
videosSchema.methods = {}


const Videos = mongoose.model('Videos', videosSchema)
module.exports = Videos