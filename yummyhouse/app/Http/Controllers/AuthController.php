<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Auth\Events\Registered;
use Illuminate\Foundation\Auth\EmailVerificationRequest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $message = 'User registered successfully. Please verify your email.';

        $fields = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255',
            'password' => 'required|string|min:8',
        ]);

        // Get user model instance (not just the query)
        $user = User::where('email', $fields['email'])->first();

        // If verified user already exists, block registration
        if ($user && $user->hasVerifiedEmail()) {
            return response()->json(['message' => 'User already exists.'], 409);
        }

        // If user does not exist, create new one
        if (!$user) {
            $user = User::create([
                'name' => $fields['name'],
                'email' => $fields['email'],
                'password' => bcrypt($fields['password']),
            ]);
        } else {
            // User exists but not verified — update info
            $user->name = $fields['name'];
            $user->password = bcrypt($fields['password']);
            $user->save();
            $message = 'User already exists. Please verify your email.';
        }

        // Generate token
        $token = $user->createToken('auth_token')->plainTextToken;

        // Fire registration event (used for email verification)
        event(new Registered($user));

        return response()->json([
            'message' => $message,
            'user' => $user,
            'token' => $token,
        ], 201);
    }

    public function login(Request $request)
    {
        $fields = $request->validate([
            'email' => 'required|string|email',
            'password' => 'required|string',
        ]);

        $user = User::where('email', $fields['email'])->first();

        if (!$user || !Hash::check($fields['password'], $user->password)) {
            return response()->json(['message' => 'Invalid credentials.'], 401);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'user' => $user,
            'token' => $token,
        ], 200);
    }

    public function verificationNotice(Request $request)
    {
        return response()->json(['message' => 'Verification link has been sent to your email.']);
    }

    public function verify(EmailVerificationRequest $request, $id, $hash)
    {
        // Validate the email verification request
        $request->fulfill();

        if ($request->user()->hasVerifiedEmail()) {
            return response()->json(['message' => 'Email already verified.']);
        }

        return response()->json(['message' => 'Email verified successfully']);
    }

    public function resend(Request $request)
    {
        $request->user()->sendEmailVerificationNotification();

        return response()->json([
            'message' => "Verification link sent!"
        ]);
    }

    public function logout(Request $request)
    {
        $request->user()->tokens()->delete();

        return response()->json(['message' => 'Logged out']);
    }

    public function user(Request $request)
    {
        $user = $request->user();

        if (!$user->hasVerifiedEmail()) {
            return response()->json([
                'message' => 'Email address is not verified.'
            ], 403);
        }

        return response()->json($user);
    }
}
