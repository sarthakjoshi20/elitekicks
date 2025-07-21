var express = require('express');
var router = express.Router();
var exe = require('./../connection');
var fs = require('file-system');

router.get('/',function(req,res){
    res.render("admin/home.ejs");
});

router.get('/product_brand',async function(req,res){
    try{
        var sql=`SELECT * FROM product_brands`
        var result=await exe(sql)
    }catch(err){}
    //res.send(result)
    res.render("admin/product_brand.ejs",{result:result});
});

router.post('/save_product_brand',async function(req,res){
    try{
        if(req.files){
            var file_name= new Date().getTime()+req.files.product_brand_image.name;
            req.files.product_brand_image.mv("public/product_brands/"+file_name);
        }else{
            var file_name=null;
        }
        var d = req.body;
        var sql = `INSERT INTO product_brands(product_brand_name,product_brand_image) VALUES (?,?)`;
        var result = await exe(sql,[d.product_brand_name,file_name]);
    }catch(err){}
    //res.send(result)
    res.redirect("product_brand")
});

router.post('/update_product_brand',async function(req,res){
    try{
        if(req.files){
            var file_name= new Date().getTime()+req.files.product_brand_image.name;
            req.files.product_brand_image.mv("public/product_brands/"+file_name);
            fs.unlink("public/product_brands/"+req.body.product_brand_image,(err)=>{
                console.log(err);
            })
        }else{
            var file_name=req.body.product_brand_image;
        }
        var d=req.body;
        var sql=`UPDATE product_brands SET 
        product_brand_name = ?,
        product_brand_image = ?,
        status = ? WHERE
        product_brand_id = ?`
        var result=await exe(sql,[d.product_brand_name,file_name,d.status,d.product_brand_id])
    }catch(err){}
    res.redirect("/admin/product_brand")
})

router.get("/delete_product_brand/:tid", async function(req, res) {
    var tid = req.params.tid;
    var sql = `DELETE FROM product_brands WHERE product_brand_id = ?`;
    var info = await exe(sql, [tid]);
    res.redirect("/admin/product_brand");
});

router.get('/product_styles',async function(req,res){
        var sql=`SELECT * FROM product_styles`
        var result=await exe(sql)
        res.render("admin/product_styles.ejs",{result:result})
});

router.post('/save_product_style',async function(req,res){
    try{
        if(req.files){
            var file_name= new Date().getTime()+req.files.product_style_image.name;
            req.files.product_style_image.mv("public/product_styles/"+file_name);
            fs.unlink("public/product_styles/"+req.body.product_style_image,(err)=>{
                console.log(err);
            })
        }else{
            var file_name=null;
        }
        var d=req.body;
        var sql=`INSERT INTO product_styles(product_style_name,product_style_image) VALUES (?,?)`;
        var result=await exe(sql,[d.product_style_name,file_name]);
    }catch(err){}
    res.redirect("product_styles")
});

router.post('/update_product_style',async function(req,res){
    try{
        if(req.files){
            var file_name= new Date().getTime()+req.files.product_style_image.name;
            req.files.product_style_image.mv("public/product_styles/"+file_name);
            fs.unlink("public/product_styles/"+req.body.product_style_image,(err)=>{
                console.log(err);
            })
        }else{
            var file_name=req.body.product_style_image;
        }
        var d=req.body;
        var sql=`UPDATE product_styles SET 
        product_style_name = ?,
        product_style_image = ?,
        status = ? WHERE
        product_style_id = ?`
        var result=await exe(sql,[d.product_style_name,file_name,d.status,d.product_style_id])
    }catch(err){}
    res.redirect("/admin/product_styles")
});

router.get("/delete_product_style/:tid", async function(req, res) {
    var tid = req.params.tid;
    var sql = `DELETE FROM product_styles WHERE product_style_id = ?`;
    var info = await exe(sql, [tid]);
    res.redirect("/admin/product_styles");
});

router.get('/product_types',async function(req,res){
        var sql=`SELECT * FROM product_types`
        var result=await exe(sql)
        res.render("admin/product_types.ejs",{result})   
});

router.post('/save_product_types',async function(req,res){
    try{
        if(req.files){
            var file_name= new Date().getTime()+req.files.product_type_image.name;
            req.files.product_type_image.mv("./public/product_types/"+file_name);
        }else{
            var file_name=null;
        }
        var d=req.body;
        var sql=`INSERT INTO product_types(product_type_name,product_type_image) VALUES (?,?)`;
        var result=await exe(sql,[d.product_type_name,file_name]);
    }catch(err){}
    res.redirect("product_types");
});

router.get("/delete_product_type/:tid", async function(req, res) {
        var tid = req.params.tid;
        var sql = `DELETE FROM product_types WHERE product_type_id = ?`;
        var info = await exe(sql, [tid]);
        res.redirect("/admin/product_types");
});


router.post('/update_product_type',async function(req,res){
    try{
        var d=req.body;
        if(req.files){
            var file_name= new Date().getTime()+req.files.product_type_image.name;
            req.files.product_type_image.mv("public/product_types/"+file_name);
            fs.unlink("public/product_types/"+req.body.product_type_image,(err)=>{  
                console.log(err);
            })
        }else{
            var file_name=req.body.product_type_image;
        }
        var sql=`UPDATE product_types SET 
        product_type_name = ?,
        product_type_image = ?,
        status = ? WHERE
        product_type_id = ?`
        var result=await exe(sql,[d.product_type_name,file_name,d.status,d.product_type_id])
    }catch(err){}
    res.redirect("/admin/product_types")
});


router.get('/add_product',async function(req,res){
    var brands=await exe("SELECT * FROM product_brands");
    var styles=await exe("SELECT * FROM product_styles");
    var types=await exe("SELECT * FROM product_types");
    res.render("admin/add_product.ejs",{brands,styles,types})
})
router.post('/save_product',async function(req, res) {
    try{
        var d=req.body;
        if(req.files){
            var file_name=new Date().getTime()+req.files.product_main_image.name;
            req.files.product_main_image.mv("public/products/"+file_name);
        }else{
            var file_name=null;
        }
        var applicable_discount=100 - Number(d.product_price)*100 / Number(d.product_market_price);
        var sql=`INSERT INTO products(product_name,
        product_market_price,
        apply_discount_percent,
        product_price,
        product_main_image,
        product_is_trending,
        product_brand_id,
        product_style_id,
        product_type_id,
        product_for,
        product_kid_type,
        product_stock,
        product_color,
        product_description) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)`;
        var result=await exe(sql,[d.product_name,
            d.product_market_price,
            applicable_discount,
            d.product_price,
            file_name,
            d.product_is_trending,
            d.product_brand_id,
            d.product_style_id,
            d.product_type_id,
            d.product_for,
            d.product_kid_type,
            d.product_stock,
            d.product_color,
            d.product_description]);
    }catch(err){}
    res.redirect("/admin/add_product");
});

router.get('/product_list',async function(req,res){
    var sql=`SELECT * FROM products,product_brands,product_styles,product_types 
    WHERE 
    products.product_brand_id = product_brands.product_brand_id AND 
    products.product_style_id = product_styles.product_style_id AND 
    products.product_type_id = product_types.product_type_id`
    var result=await exe(sql);
    var brands=await exe("SELECT * FROM product_brands");
    var styles=await exe("SELECT * FROM product_styles");
    var types=await exe("SELECT * FROM product_types");
    res.render("admin/product_list.ejs",{result,brands,styles,types})
});

router.get("/delete_product/:id",async function(req,res){
    var id=req.params.id;
    var sql=`DELETE FROM products WHERE product_id = ${id}`;
    var result=await exe(sql);
    res.redirect("/admin/product_list");
});

router.post("/update_product",async function(req,res){
    try{
        if(req.files){
            var file_name=new Date().getTime()+req.files.product_main_image.name;
            req.files.product_main_image.mv("public/products/"+file_name);
            fs.unlink("public/products/"+req.body.product_main_image,(err)=>{
                console.log(err);
            })
        }else{
            var file_name=req.body.product_main_image;
        }
        if(req.body.product_description.length>0){
            var product_description=req.body.product_description;
        }else{
            var product_description=req.body.product_description2;
        }
    var d=req.body;
    var sql=`UPDATE products SET 
    product_name = ?,
    product_main_image = ?,
    product_market_price = ?,
    product_price = ?,
    product_is_trending = ?,
    product_brand_id = ?,
    product_style_id = ?,
    product_type_id = ?,
    product_for = ?,
    product_kid_type = ?,
    product_stock = ?,
    product_color = ?,
    product_description = ? WHERE product_id = ?`
    var result=await exe(sql,[d.product_name,file_name,d.product_market_price,d.product_price,d.product_is_trending,d.product_brand_id,d.product_style_id,d.product_type_id,d.product_for,d.product_kid_type,d.product_stock,d.product_color,product_description,d.product_id])
    }catch(err){}
    res.redirect("/admin/product_list")
});

router.get("/slider_images",async function(req,res){
    var sql=`SELECT * FROM sliders`
    var result=await exe(sql)
    res.render("admin/slider_images.ejs",{result})
    //res.send(result)
})

router.post("/add_slider",async function(req,res){
    try{
        if(req.files){
            var file_name=new Date().getTime()+req.files.slider_image.name;
            req.files.slider_image.mv("public/sliders/"+file_name);
        }else{
            var file_name=null;
        }
        var d=req.body;
        var sql=`INSERT INTO sliders(slider_title,slider_image,slider_description,slider_button_text,slider_button_link) VALUES (?,?,?,?,?)`;
        var result=await exe(sql,[d.slider_title,file_name,d.slider_description,d.slider_button_text,d.slider_button_link]);
    }catch(err){}
    res.redirect("/admin/slider_images")
});

router.get("/delete_slider/:id",async function(req,res){
    var id=req.params.id;
    var sql=`DELETE FROM sliders WHERE slider_id = ${id}`;
    var result=await exe(sql);
    res.redirect("/admin/slider_images")
});



module.exports = router;