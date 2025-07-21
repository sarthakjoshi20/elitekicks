var express = require('express');
var router = express.Router();
var exe = require('./../connection');
var url=require('url');
var sendMail=require('./send_mail');

router.get('/',async function(req,res){
    var sliders=await exe(`SELECT * FROM sliders`);
    var trending_products=await exe(`SELECT * FROM products WHERE product_is_trending= 'yes'`);
    var product_types=await exe(`SELECT * FROM product_types`);
    var product_styles=await exe(`SELECT * FROM product_styles`);

    var high_discount_products=await exe(`SELECT * FROM products ORDER BY apply_discount_percent DESC LIMIT 6`);

    var packet={sliders,trending_products,product_types,product_styles,high_discount_products};
    res.render("user/home.ejs",packet);
});

router.get('/product_list',async function(req,res){
    var url_data=url.parse(req.url,true).query;
    var sql=`SELECT * FROM products`;
    if(url_data.cat){
        if(url_data.cat=='Mens')
            var sql=`SELECT * FROM products WHERE product_for='Male'`;
        if(url_data.cat=='Womens')
            var sql=`SELECT * FROM products WHERE product_for='Female'`;
        if(url_data.cat=='KidBoys')
            var sql=`SELECT * FROM products WHERE product_for='Kids' AND product_kid_type='Boys '`;
        if(url_data.cat=='KidGirls')
            var sql=`SELECT * FROM products WHERE product_for='Kids' AND product_kid_type='Girls'`;
    }
    var products=await exe(sql);
    var packet={products};
    res.render("user/product_list.ejs",packet);
});

router.get('/product_details/:id',async function(req,res){
    var id=req.params.id;
    var product=await exe(`SELECT * FROM products WHERE product_id=${id}`);

    var is_login= (req.session.user_id)? true : false;


    var packet={product,is_login};
    res.render("user/product_details.ejs",packet);
});

router.get('/buy_now/:id',async function(req,res){    
    res.send("user/buy_now.ejs");
});

router.post('/send_otp_mail',async function(req,res){
    var otp=parseInt(Math.random()*10000+999);
    var to_mail=req.body.email;
    var subject="ELITE KICKS OTP VERIFICATION";
    var message=`Your One Time Password (OTP) is ${otp}`;
    req.session.otp=otp;
    req.session.email=req.body.email;
    sendMail(to_mail,subject,message);
    res.send(req.body);
})

router.post('/verify_otp',async function(req,res){
    var otp=req.body.otp1+req.body.otp2+req.body.otp3+req.body.otp4;
    if(req.session.otp==otp){
        var check_customer=await exe(`SELECT * FROM customers WHERE customer_email='${req.session.email}'`);
        if(check_customer.length>0){
            res.send("Customer already exists");
        }else{
            res.send("Customer not exists");
        }
        res.send("OTP verified");
    }else{
        res.send("Invalid OTP"); 
    }
    res.send(otp);
})
module.exports = router;