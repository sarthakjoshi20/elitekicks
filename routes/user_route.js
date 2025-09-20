var express = require('express');
var router = express.Router();
var exe = require('./../connection');
var url=require('url');
var sendMail=require('./send_mail');
const { send } = require('emailjs-com');


router.get('/',async function(req,res){
    var sliders=await exe(`SELECT * FROM sliders`);
    var trending_products=await exe(`SELECT * FROM products WHERE product_is_trending= 'yes'`);
    var product_types=await exe(`SELECT * FROM product_types`);
    var product_styles=await exe(`SELECT * FROM product_styles`);

    var high_discount_products=await exe(`SELECT * FROM products ORDER BY apply_discount_percent DESC LIMIT 6`);
    var is_login= (req.session.user_id)? true : false;

    var packet={sliders,trending_products,product_types,product_styles,high_discount_products, is_login};
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
    var is_login= (req.session.user_id)? true : false;
    var packet={products,is_login};
    res.render("user/product_list.ejs",packet);
});

router.get('/product_details/:id',async function(req,res){
    var id=req.params.id;
    var product=await exe(`SELECT * FROM products WHERE product_id=${id}`);

    var is_login= (req.session.user_id)? true : false;


    var packet={product,is_login};
    res.render("user/product_details.ejs",packet);
});

router.get('/buy_now/:id',check_login,async function(req,res){
    var url_data=url.parse(req.url,true).query;
    var id=req.params.id;
    var is_login= (req.session.user_id)? true : false;
    var product=await exe(`SELECT * FROM products WHERE product_id=${id}`);
    var packet={product,url_data,is_login};
    res.render("user/buy_now.ejs",packet);
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
});

async function transfer_data(req,res){
    var carts = req.cookies.cart;
    try{
        for(var i=0;i<carts.length;i++){
        var customer_id = req.session.user_id;
        var product_id= carts[i].product_id;
        var qty=carts[i].qty;
        var size=carts[i].size;

        var sql=`INSERT INTO carts (customer_id,product_id,qty,size) VALUES (?,?,?,?)`;
        var result=await exe(sql,[customer_id,product_id,qty,size]);
    }}catch(err){}
};

router.post('/verify_otp',async function(req,res){
    var email=req.session.email;
    var otp=req.body.otp;
    var sql=`SELECT * FROM customers WHERE customer_email='${email}'`;
    var check_customer=await exe(sql);

    if(req.session.otp==otp){
        var check_customer=await exe(`SELECT * FROM customers WHERE customer_email='${req.session.email}'`);
        if(check_customer.length>0){
            req.session.user_id=check_customer[0].customer_id;
            await transfer_data(req,res);
            res.send({"status":"success","new_user":false});
        }else{
            var sql2=`INSERT INTO customers (customer_email) VALUES ('${email}')`;
            var result=await exe(sql2);
            req.session.user_id=result.insertId;
            await transfer_data(req,res);
            res.send({"status":"success","new_user":true});
        }
    }else{
        res.send({"status":"false"}); 
    }
});

function check_login(req,res,next){
    // Middleware to check if user is logged in
    // If user is logged in, proceed to the next middleware or route handler 
    // If user is not logged in, redirect to login page
    if(req.session.user_id){
        next();
    }else{
        res.redirect("/");
    }
}

router.get('/logout', check_login, (req, res) => {
    req.session.destroy(err => {
        if (err) {
            console.error("Error destroying session:", err);
            return res.status(500).send("Logout failed");
        }
        res.clearCookie("connect.sid"); // clear cookie (optional but good practice)
        res.redirect("/");
    });
});

router.post('/checkout',check_login,async function(req,res){
    var d=req.body;
    var customer_id=req.session.user_id;

    var product_info = await exe(`SELECT * FROM products WHERE product_id=${d.product_id}`);
    var total_amount=product_info[0].product_price*d.qty;
    var payment_method="Online";
    var payment_status="Pending";
    var order_date=new Date().toISOString().slice(0,10);
    var order_status="placed";

    var sql=`INSERT INTO orders (customer_id,fullname,mobile,country,state,city,area,pincode,total_amount,payment_method,payment_status,order_date,order_status) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)`;
    var result=await exe(sql,[customer_id,d.fullName,d.mobile,d.country,d.state,d.city,d.address,d.pincode,total_amount,payment_method,payment_status,order_date,order_status]);

    var order_id=result.insertId;
    var product_id=d.product_id;
    var product_name=product_info[0].product_name;
    var product_size=d.size;
    var product_market_price=product_info[0].product_market_price;
    var product_discount =product_info[0].apply_discount_percent;
    var product_price=product_info[0].product_price;
    var product_qty=d.qty;
    var product_total = product_price*d.qty;

    var sql2=`INSERT INTO order_products (order_id,customer_id,product_id,product_name,product_size,product_market_price,product_discount,product_price,product_qty,product_total) VALUES (?,?,?,?,?,?,?,?,?,?)`;
    var result2=await exe(sql2,[order_id,customer_id,product_id,product_name,product_size,product_market_price,product_discount,product_price,product_qty,product_total]);
    res.redirect("/accept_payment/"+order_id);
});

router.get('/accept_payment/:order_id',check_login,async function(req,res){
    var order_id=req.params.order_id;
    var sql=`SELECT * FROM orders WHERE order_id=${order_id}`;
    var order_info=await exe(sql);
    var packet={order_info};
    res.render("user/accept_payment.ejs",packet);
});

router.post('/payment_success/:order_id',check_login,async function(req,res){
    var order_id=req.params.order_id;
    var sql=`UPDATE orders SET payment_status='paid',transaction_id='${req.body.razorpay_payment_id}' WHERE order_id=${order_id}`;
    var result=await exe(sql);
    res.redirect("/my_orders");
});

router.get('/my_orders',check_login,async function(req,res){
    var is_login= (req.session.user_id)? true : false;

    var sql=`SELECT * FROM orders WHERE customer_id=${req.session.user_id}`;
    var orders=await exe(sql);
    console.log(orders);
    res.render("user/my_orders.ejs",{orders,is_login});
})

router.get('/view_orders/:order_id',check_login,async function(req,res){
    var is_login= (req.session.user_id)? true : false;

    var sql=`SELECT * FROM orders WHERE customer_id=${req.session.user_id} AND order_id=${req.params.order_id}`;
    var orders=await exe(sql);
    var sql2=`SELECT * FROM order_products WHERE order_id =${req.params.order_id}`
    var info=await exe(sql2);
    res.render("user/view_orders.ejs",{orders,info,is_login});
})

router.get('/add_to_cart/:id',async function(req,res){
    var product_id=req.params.id;
    var url_data=url.parse(req.url,true).query;

    if(req.session.user_id){
        var customer_id=req.session.user_id;
        var qty=url_data.qty;
        var size=url_data.size;

        var sql=`SELECT * FROM carts WHERE customer_id = ? AND product_id = ? AND size = ?`;
        var info=await exe(sql,[customer_id,product_id,size]);

        if(info.length>0)
        {}
        else
        {
            var sql=`INSERT INTO carts (customer_id,product_id,qty,size) VALUES (?,?,?,?)`;
            var result=await exe(sql,[customer_id,product_id,qty,size]);
        }
        res.redirect(`/product_details/${product_id}`);
    }
    else{
        var cart = req.cookies.cart;
        var obj = {"product_id":product_id,"size":url_data.size,"qty":url_data.qty};
        if(cart == undefined){
            var data=[obj];
            res.cookie("cart",data)
        }else{
            var already = false;
            for(var i=0;i<cart.length;i++)
                {
                    if(cart[i].product_id == product_id && cart[i].size == url_data.size){
                        already = true;
                    }
                }
                if(already == false){
                    cart.push(obj);
                    res.cookie("cart",cart);
                }
            }
            res.redirect(`/product_details/${product_id}`);
        }
    });


router.get('/cart',async function(req,res){
    if(req.session.user_id){
        var customer_id=req.session.user_id;
        var sql=`SELECT * FROM carts WHERE customer_id=?`;
        var carts=await exe(sql,[customer_id]);
    }else{
        if(req.cookies.cart){
            var carts=req.cookies.cart;
        }else{
            var carts=[];
        }
    }

    var cart_data = [];
    for(var i=0;i<carts.length;i++){
        var product_info=await exe(`SELECT * FROM products WHERE product_id=${carts[i].product_id}`);
        var obj={
            "cart_id":(carts[i].cart_id) ? carts[i].cart_id:i,
            "product_name":product_info[0].product_name,
            "product_image":product_info[0].product_main_image,
            "product_price":product_info[0].product_price,
            "product_discount":product_info[0].apply_discount_percent,
            "product_qty":carts[i].qty,
            "product_size":carts[i].size,
        }
        cart_data.push(obj);
    }
    var is_login=(req.session.user_id)?true:false
    var packet={cart_data,is_login}
    res.render("user/cart.ejs",packet);
});

router.get("/delete_cart/:id",async function(req,res){
    var id=req.params.id;
    if(req.session.user_id){
        var sql=`DELETE FROM carts WHERE cart_id = ?`
        var result=await exe(sql,[id])
        res.redirect("/cart")
    }else{
        var carts = req.cookies.cart;

        carts.splice(id,1);
        res.cookie("cart",carts)
        res.redirect("/cart")
    }
});


router.get('/user_login',function(req,res){
    
    var is_login=(req.session.user_id)?true:false
    var packet={is_login};
    res.render("user/user_login.ejs",packet);
});

router.get('/user_profile',check_login,async function(req,res){
    var is_login=(req.session.user_id)?true:false
    var packet={is_login};
    res.render("user/user_profile.ejs",packet);
});

router.post('/place_order',check_login,async function(req,res){
    var customer_id=req.session.user_id;
    var fullname=req.body.fullName;
    var mobile=req.body.mobile;
    var country=req.body.country;
    var state=req.body.state;
    var city=req.body.city;
    var area=req.body.address;
    var pincode=req.body.pincode;

    var total_amount=0;
    var user_carts=await exe(`SELECT SUM(qty*product_price) as total_amount FROM carts,products WHERE carts.product_id = products.product_id AND customer_id=${customer_id}`);
    var total_amount = user_carts[0].total_amount;
    var payment_method="Online";
    var payment_status="pending";
    var order_date=new Date().toISOString().slice(0,10);
    var order_status="placed";


    var sql=`INSERT INTO orders (customer_id,fullname,mobile,country,state,city,area,pincode,total_amount,payment_method,payment_status,order_date,order_status) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)`;
    var result=await exe(sql,[customer_id,fullname,mobile,country,state,city,area,pincode,total_amount,payment_method,payment_status,order_date,order_status]);
    
    var sql= `SELECT * FROM carts,products WHERE carts.product_id = products.product_id`;
    var carts=await exe(sql);
    for(var i=0;i<carts.length;i++){
        var order_id=result.insertId;
        var product_id=carts[i].product_id;
        var product_name=carts[i].product_name;
        var product_size=carts[i].size;
        var product_market_price=carts[i].product_market_price;
        var product_discount=carts[i].apply_discount_percent;
        var product_price=carts[i].product_price;
        var product_qty=carts[i].qty;
        var product_total=product_price*product_qty;

        var sql2=`INSERT INTO order_products (order_id,customer_id,product_id,product_name,product_size,product_market_price,product_discount,product_price,product_qty,product_total) VALUES (?,?,?,?,?,?,?,?,?,?)`;
        await exe(sql2,[order_id,customer_id,product_id,product_name,product_size,product_market_price,product_discount,product_price,product_qty,product_total]);

        var sql=`DELETE FROM carts WHERE customer_id = ${req.session.user_id}`;
        var result3=await exe(sql);
        res.redirect("/accept_payment/"+order_id);
    }
});
module.exports = router;