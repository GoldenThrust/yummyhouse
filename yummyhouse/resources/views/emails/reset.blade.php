<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Reset Your Password</title>
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
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>YummyHouse</h2>
        </div>
        <div class="content">
            <h1>Reset Your Password</h1>
            
            <p>Hello,</p>
            
            <p>We received a request to reset the password for your YummyHouse account.</p>
            
            <div class="highlight">
                <p>To reset your password, please click on the button below:</p>
            </div>
            
            <div style="text-align: center;">
                <a href="{{ $url }}" class="button">Reset Password</a>
            </div>
            
            <div class="link-fallback">
                If the button above doesn't work, copy and paste this link into your browser: <br>
                {{ $url }}
            </div>
            
            <div class="divider"></div>
            
            <p>This password reset link will expire in 60 minutes.</p>
            
            <p>If you did not request a password reset, no further action is required and your account remains secure.</p>
            
            <p>Regards,<br>The YummyHouse Team</p>
        </div>
        <div class="footer">
            <p>&copy; {{ date('Y') }} YummyHouse. All rights reserved.</p>
            <p>This is an automated email, please do not reply.</p>
        </div>
    </div>
</body>
</html>
