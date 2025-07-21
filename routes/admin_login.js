var express = require('express');
var router = express.Router();
var exe = require('./../connection');

router.get('/',(req,res)=>{
    res.render("admin/login.ejs");
})

module.exports = router;