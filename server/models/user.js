const mongoose=require("mongoose");
const { productSchema } = require("./product");

const userSchema=mongoose.Schema({
    name:{
        type:String,
        required:true,
        trim:true,
    },
    email:{
        type:String,
        trim:true,
        required:true,
        validate:{
            validator:(value)=>{
                const re=/^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|.(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
                return value.match(re);

            },
            message:"please enter the valid email address",
        }
    },
    password:{
        type:String,
        required:true,
        validator: (value)=>{
            return value.length>6;
        },
        message:"Password is too Short",
    },
    address:{
        type:String,
        default:"",
    },
    type:{
        type:String,
        default:"user",
    },
    cart:[
        {
            product:productSchema,
            quantity:{
                type:Number,
                required:true
            }
        }
    ]
})

const User=mongoose.model("User",userSchema);
module.exports=User;