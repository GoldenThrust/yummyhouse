<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Verify Your Email Address</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 600px;
            margin: 20px auto;
            background-color: #ffffff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .header {
            text-align: center;
            padding: 25px 0;
            background-color: #FF7A00;
            color: white;
        }
        .header h2 {
            margin: 0;
            font-size: 24px;
            letter-spacing: 1px;
        }
        .content {
            padding: 30px;
        }
        .button {
            display: inline-block;
            padding: 14px 30px;
            background-color: #FF7A00;
            color: #ffffff;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
            margin: 20px 0;
            box-shadow: 0 2px 5px rgba(255, 122, 0, 0.3);
        }
        .footer {
            text-align: center;
            padding: 20px;
            background-color: #f8f8f8;
            border-top: 1px solid #eeeeee;
            font-size: 13px;
            color: #777;
        }
        h1 {
            color: #FF7A00;
            margin-top: 0;
            font-size: 22px;
        }
        .highlight {
            background-color: #FFF4E9;
            border-left: 4px solid #FF7A00;
            padding: 15px;
            margin: 20px 0;
        }
        .link-fallback {
            word-break: break-all;
            font-size: 13px;
            color: #555;
            margin-top: 15px;
            padding: 10px;
            background-color: #f5f5f5;
            border-radius: 4px;
        }
        .divider {
            height: 1px;
            background-color: #eeeeee;
            margin: 25px 0;
        }
        .welcome-box {
            text-align: center;
            margin-bottom: 20px;
        }
        .welcome-box img {
            max-width: 100px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>YummyHouse</h2>
        </div>
        <div class="content">
            <div class="welcome-box">
                <h1>Welcome to YummyHouse!</h1>
            </div>
            
            <p>Hello {{ $name ?? 'there' }},</p>
            
            <p>Thank you for registering with YummyHouse! We're excited to have you join our community of food lovers.</p>
            
            <div class="highlight">
                <p>Please verify your email address by clicking the button below to activate your account:</p>
            </div>
            
            <div style="text-align: center;">
                <a href="{{ $url }}" class="button">Verify Email Address</a>
            </div>
            
            <div class="link-fallback">
                If the button above doesn't work, copy and paste this link into your browser: <br>
                {{ $url }}
            </div>
            
            <div class="divider"></div>
            
            <p>This verification link will expire in 24 hours.</p>
            
            <p>After verification, you'll have full access to all YummyHouse features and services.</p>
            
            <p>If you did not create an account, no further action is required.</p>
            
            <p>Bon Appétit!<br>The YummyHouse Team</p>
        </div>
        <div class="footer">
            <p>&copy; {{ date('Y') }} YummyHouse. All rights reserved.</p>
            <p>Questions? Contact us at <a href="mailto:support@yummyhouse.com" style="color: #FF7A00;">support@yummyhouse.com</a></p>
        </div>
    </div>
</body>
</html>
