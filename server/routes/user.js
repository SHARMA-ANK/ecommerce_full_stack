const express=require("express");
const userRouter=express.Router();
const mongoose=require("mongoose");
const {Product}=require('../models/product');
const auth = require("../middlewares/auth");
const User = require("../models/user");
userRouter.post("/api/add-to-cart", auth, async (req, res) => {
    try {
        const { id } = req.body;
console.log(id);
    // Verify the ID format
    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ error: "Invalid product ID format" });
    }

    // Fetch the product by ID
    const product = await Product.findById(id);
    if (!product) {
      return res.status(404).json({ error: "Product not found" });
    }

    // Fetch the user by ID from the middleware
    let user = await User.findById(req.x);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    // Filter out any null products from the user's cart
    user.cart = user.cart.filter(item => item.product);

    let isProductFound = false;

    // Loop through the cart to find the product
    for (let i = 0; i < user.cart.length; i++) {
      if (user.cart[i].product._id.equals(product._id)) {
        isProductFound = true;
        user.cart[i].quantity += 1;
        break;
      }
    }

    // If product is not found in the cart, add it
    if (!isProductFound) {
      user.cart.push({ product, quantity: 1 });
    }

    // Save the updated user
    user = await user.save();
    res.json(user);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });

  userRouter.delete("/api/remove-from-cart/:id", auth, async (req, res) => {
    try {
      const { id } = req.params;
      const product = await Product.findById(id);
      let user = await User.findById(req.x);
  
      for (let i = 0; i < user.cart.length; i++) {
        if (user.cart[i].product._id.equals(product._id)) {
          if (user.cart[i].quantity == 1) {
            user.cart.splice(i, 1);
          } else {
            user.cart[i].quantity -= 1;
          }
        }
      }
      user = await user.save();
      res.json(user);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });
  
module.exports=userRouter;