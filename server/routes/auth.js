const express=require("express");
const User = require("../models/user");
const bcryptjs=require("bcryptjs")
const authRouter=express.Router();
const jwt=require('jsonwebtoken');
const auth = require("../middlewares/auth");

authRouter.post('/api/signup',async (req,res)=>{
    try{
        const {name,email,password}=req.body;
    const existingUser=await User.findOne({email});
    if(existingUser){
        return res.status(400).json({
            msg:"User with same email already exisits"
        })
    }
    const hashedPassword=await bcryptjs.hash(password,8);
    let user=new User({
        email,
        password:hashedPassword,
        name
    })
    user=await user.save();
    res.json(user);
    }catch(e){
        res.status(500).json({error:e.message});
    }
});

authRouter.post('/api/signin',async (req,res)=>{
    try{
        const {email,password}=req.body;
        const user=await User.findOne({email});
        if(!user){
            return res.status(400).json({msg:"Either username or the password is wrong please check it! "})
        }
        const ismatch=await bcryptjs.compare(password,user.password);
        if(!ismatch){
            return res.status(400).json({msg:"Either username or the password is wrong please check it! "});
        }
        const token=await jwt.sign({id:user._id},"password_key");
        res.json({token,...user._doc});

    }catch(e){
        res.status(500).json({error:e.message});
    }

});

authRouter.post('/tokenIsValid',async (req,res)=>{
    try{
        const token=req.header('x-auth-token');
        if(!token) return rjson(false);
        const verified=jwt.verify(token,'password_key');
        if(!verified) return res.json(false);
        const user=await User.findById(verified.id);
        if(!user) return res.json(false);
        return res.json(true);
    }catch(e){
        res.status(500).json({error:e.message});
    }
});
authRouter.get('/',auth,async (req,res)=>{
    const user=await User.findById(req.x);
    return res.json({...user._doc,token:req.token});
})

module.exports=authRouter;