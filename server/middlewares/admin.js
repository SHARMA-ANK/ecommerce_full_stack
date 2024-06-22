const jwt=require("jsonwebtoken");
const User = require("../models/user");

const admin=async(req,res,next)=>{
    try{
        const token=req.header('x-auth-token');
        if(!token){
            return res.status(401).json({msg:"No auth Token. Access Denied!"});
        }
        const verified=await jwt.verify(token,"password_key");
        if(!verified){
            return res.status(401).json({msg:"Token Verification Failed. Access Denied!"});
        }
        const user=await User.findById(verified.id);

        if(user.type!='admin'){
            return res.status(401).json({msg:"Yo are not the admin"});
        }
        req.x=verified.id;
        req.token=token;
        next();

    }catch(e){
        return res.status(500).json({
            error:e.message,
        })
    }
}
module.exports=admin;