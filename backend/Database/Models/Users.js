const mongoose = require('mongoose')
const Schema = mongoose.Schema
mongoose.promise = Promise

// Define userSchema
const usersSchema = new Schema({
    username: { type: String, unique: true, required: true},
    password: { type: String, unique: false, required: true},
    feed: {type: Array, unique: false, default: [], required: false},
    numUpvotes: {type: Number, unique: false, default: 0, required: true},
    interests: {
        adult: { type: Number, unique: false, default: 1, required: true},
        arts_and_enterainment: { type: Number, unique: false, default: 1, required: true},
        autos_and_vehicles: { type: Number, unique: false, default: 1, required: true},
        beauty_and_fitness: { type: Number, unique: false, default: 1, required: true},
        books_and_literature: { type: Number, unique: false, default: 1, required: true},
        business_and_industrial: { type: Number, unique: false, default: 1, required: true},
        computers_and_electronics: { type: Number, unique: false, default: 1, required: true},
        finance: { type: Number, unique: false, default: 1, required: true},
        food_and_drink: { type: Number, unique: false, default: 1, required: true},
        games: { type: Number, unique: false, default: 1, required: true},
        health: { type: Number, unique: false, default: 1, required: true},
        hobbies_and_leisure: { type: Number, unique: false, default: 1, required: true},
        home_and_garden: { type: Number, unique: false, default: 1, required: true},
        internet_and_telecom: { type: Number, unique: false, default: 1, required: true},
        jobs_and_education: { type: Number, unique: false, default: 1, required: true},
        law_and_government: { type: Number, unique: false, default: 1, required: true},
        news: { type: Number, unique: false, default: 1, required: true},
        online_communities: { type: Number, unique: false, default: 1, required: true},
        people_and_society: { type: Number, unique: false, default: 1, required: true},
        pets_and_animals: { type: Number, unique: false, default: 1, required: true},
        real_estate: { type: Number, unique: false, default: 1, required: true},
        reference: { type: Number, unique: false, default: 1, required: true},
        science: { type: Number, unique: false, default: 1, required: true},
        sensitive_subjects: { type: Number, unique: false, default: 1, required: true},
        shopping: { type: Number, unique: false, default: 1, required: true},
        sports: { type: Number, unique: false, default: 1, required: true},
        travel: { type: Number, unique: false, default: 1, required: true},
        other: { type: Number, unique: false, default: 1, required: true},
    }
}, { collection: "Users"})

// Define schema methods
usersSchema.methods = {}


const Users = mongoose.model('Users', usersSchema)
module.exports = Users