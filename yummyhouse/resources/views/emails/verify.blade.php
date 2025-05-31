<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Verify Your Email - Yummy House</title>
</head>
<body style="font-family: Arial, sans-serif; background: #fff; color: #333; margin: 0; padding: 0;">
    <div style="max-width: 600px; margin: auto; padding: 30px; border: 1px solid #f0f0f0;">
        <div style="text-align: center;">
            <h1 style="color: #ff6600;">Yummy House</h1>
        </div>
        <h2 style="color: #444;">Hello {{ $user->name }},</h2>
        <p style="font-size: 16px;">
            Thanks for signing up for <strong>Yummy House</strong>! Please confirm your email address by clicking the button below.
        </p>
        <div style="text-align: center; margin: 30px 0;">
            <a href="{{ $verifyUrl }}" style="background-color: #ff6600; color: #fff; padding: 12px 25px; text-decoration: none; border-radius: 5px; display: inline-block;">
                Verify Email
            </a>
        </div>
        <p style="font-size: 14px; color: #666;">
            If you didn’t create a Yummy House account, you can safely ignore this email.
        </p>

        <p style="font-size: 14px; color: #444;">
            If the button above doesn't work, copy and paste this link into your browser:
            <br>
            <a href="{{ $verifyUrl }}" style="color: #ff6600;">{{ $verifyUrl }}</a>
        </p>

        <p style="font-size: 14px; color: #aaa; float: right;">&mdash; The Yummy House Team</p>
    </div>
</body>
</html>
