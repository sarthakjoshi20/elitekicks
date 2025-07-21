const nodemailer = require("nodemailer");

// Create a test account or replace with real credentials.
const transporter = nodemailer.createTransport({
  host: "smtp.gmail.com",
  port: 587,
  secure: false, // true for 465, false for other ports
  auth: {
    user: "sarthakjoshi1899@gmail.com",
    pass: "zean hnsx pnkj pilr",
  },
});

async function sendMail(to_mail,subject,message){
    const info = await transporter.sendMail({
        from: '"Elite kicks" <sarthakjoshi1899@gmail.com>',
        to: to_mail,
        subject: subject,
        text: message, // plain‑text body
        html: message, // HTML body
      });
    
      console.log("Message sent:", info.messageId);
}

module.exports = sendMail;