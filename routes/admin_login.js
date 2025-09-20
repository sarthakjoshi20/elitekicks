var express = require('express');
var router = express.Router();
var exe = require('./../connection');

router.get('/',(req,res)=>{
    res.render("admin/login.ejs");
})

router.post('/verify_login', async function(req, res) {
    try {
        var mobile = req.body.mobile;
        var password = req.body.password;
        
        // Use parameterized queries to prevent SQL injection
        var sql = `SELECT * FROM admin WHERE admin_mobile = ? AND admin_password = ?`;
        var result = await exe(sql, [mobile, password]);
        
        if (result.length > 0) {
            // Admin found - successful login
            req.session.admin_id = result[0]; // Store admin in session
            res.redirect("/admin");
        }
    } catch (error){}
});

module.exports = router;