const mongoose = require('mongoose')


async function connetDB() {
    //place your own mongo DB connect link and password 
    await mongoose.connect('mongodb+srv://saqib:password@node-backend.djlsjl.mongodb.net/halley')
    console.log('Connected to mongoos DB')

}



module.exports = connetDB;