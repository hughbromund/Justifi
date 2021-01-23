const mongoose = require('mongoose')
const Schema = mongoose.Schema
mongoose.promise = Promise

// Define userSchema
const videosSchema = new Schema({
    uid: { type: String, unique: true, required: true},
    url: { type: String, unique: true, required: true},
    username: { type: String, unique: false, required: true},
    upvotes: { type: Number, unique: false, required: false}
    responsesUID: { type: Array, default: [], unique: false, required: false}
    isOriginal: { type: Boolean, default: true, unique: false, required: true}
}, { collection: "Videos"})

// Define schema methods
budgetSchema.methods = {}


const Videos = mongoose.model('Videos', videosSchema)
module.exports = Videos