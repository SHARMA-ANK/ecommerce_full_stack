const express=require("express");
const adminRouter=express.Router();
const admin=require('../middlewares/admin');
const { Product } = require("../models/product");

adminRouter.post('/admin/add-product',admin,async(req,res)=>{
    try{
        const{name,description,images,quantity,price,category}=req.body;
        let product=new Product({
            name,description,images,quantity,price,category
    });
        product=await product.save();
        res.json(product);
    }catch(e){
        return res.status(500).json({error:e.message});
    }
});

adminRouter.get('/admin/get-product', admin, async (req, res) => {
    try {
        const products = await Product.find(); // Fetch all products from the database
        res.json(products); // Respond with the list of products
    } catch (e) {
        return res.status(500).json({ error: e.message });
    }
});

adminRouter.post('/admin/delete-product',admin,async(req,res)=>{
    try{
        const {id}=req.body;
        let product=await Product.findByIdAndDelete(id);
        
        return res.json(product);

    }catch(e){
        return res.status(500).json({ error: e.message });

    }
})

module.exports=adminRouter;