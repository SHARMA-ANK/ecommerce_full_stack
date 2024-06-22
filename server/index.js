// import from the packages
const express=require("express");
const mongoose=require("mongoose");

//init
const app=express();
const port=3000;
const DB="mongodb+srv://ankitsharma78987:ankit123$$@cluster0.bmczvjd.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"
//imports from the inner files
const authRouter=require(
    './routes/auth'
);
const adminRouter=require(
    './routes/admin'
);
const productRouter = require("./routes/product");
const userRouter = require("./routes/user");
//middlewares
app.use(express.json());
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);




// connections

mongoose
.connect(DB).then(()=>{
    console.log("Connection Succesful")
}).catch((e)=>{
    console.log(e);
})


app.listen(port,"0.0.0.0",()=>{console.log("Server Started")},
)