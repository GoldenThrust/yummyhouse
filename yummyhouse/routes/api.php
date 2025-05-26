<?php

use App\Http\Controllers\AuthController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return response()->json([
        'message' => 'API server initialized'
    ]);
});

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Use Sanctum for all authenticated routes
Route::middleware('auth:sanctum')->group(function () {
    // Email verification routes
    Route::get('/email/verify/{id}/{hash}', [AuthController::class, 'verify'])
    ->middleware(['signed'])
    ->name('verification.verify');

    Route::post('/email/resend', [AuthController::class, 'resend'])
        ->middleware(['throttle:6,1'])
        ->name('verification.send');

    Route::get('/email/verify', [AuthController::class, 'verificationNotice'])
        ->name('verification.notice');

    // Authenticated user actions
    Route::get('/logout', [AuthController::class, 'logout']);
    Route::get('/user', [AuthController::class, 'user']);
});
