const express=require("express");
const productRouter=express.Router();
const auth = require("../middlewares/auth");
const {Product} = require('../models/product');
productRouter.get('/api/products', auth, async (req, res) => {
    try {
        const category=req.query.category;
        const products = await Product.find({category:category}); // Fetch all products from the database
        res.json(products); // Respond with the list of products
    } catch (e) {
        return res.status(500).json({ error: e.message+"500" });
    }
});

productRouter.get('/api/products/search/:name', auth, async (req, res) => {
    try {
        
        const products = await Product.find({
            name:{$regex:req.params.name,$options:"i"}
    }); // Fetch all products from the database
        res.json(products); // Respond with the list of products
    } catch (e) {
        return res.status(500).json({ error: e.message });
    }
});

productRouter.post('/api/rate-product',auth,async (req,res)=>{
    try{
        const { productId, rating } = req.body;
        const userId = req.x; // Assuming `req.user.id` contains the ID of the authenticated user

        // Find the product by ID
        const product = await Product.findById(productId);
        if (!product) {
            return res.status(404).json({ error: "Product not found" });
        }

        // Find if the user has already rated the product
        const existingRatingIndex = product.ratings.findIndex(r => r.userId.toString() === userId);
        
        if (existingRatingIndex !== -1) {
            // Update existing rating
            product.ratings[existingRatingIndex].rating = rating;
        } else {
            // Add new rating
            product.ratings.push({ userId, rating });
        }

        // Save the updated product
        await product.save();

        res.json(product); // Respond with the updated product
    } catch(e){
        res.status(500).json({error:e.message});
    }
})
productRouter.get('/api/deal-of-day',auth,async(req,res)=>{
    try{
        let products =await Product.find({});
        products=products.sort((a,b)=>{
            let aSum=0;
            let bSum=0;
            for(let i=0;i<a.ratings.length;i++){
                aSum+=a.ratings[i].rating;
            }
            for(let i=0;i<b.ratings.length;i++){
                bSum+=b.ratings[i].rating;
            }
            return aSum<bSum?1:-1;
        })
        res.json(products[0]);
    }catch(e){
        res.status(500).json({error:e.message});

    }
})

module.exports=productRouter;