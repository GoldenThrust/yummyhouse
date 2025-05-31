<?php

namespace App\Providers;

use App\Mail\CustomVerifyEmail;
use Illuminate\Auth\Notifications\VerifyEmail;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        VerifyEmail::toMailUsing(function ($notifiable, $url) {
            // Parse the URL
            $parsedUrl = parse_url($url);

            // Extract ID and hash from path
            $pathParts = explode('/', trim($parsedUrl['path'], '/'));
            $id = $pathParts[3] ?? null;
            $hash = $pathParts[4] ?? null;

            // Extract expires and signature from query string
            parse_str($parsedUrl['query'], $queryParams);
            $expires = $queryParams['expires'] ?? null;
            $signature = $queryParams['signature'] ?? null;

            // Reconstruct custom URL (e.g., mobile deep link)
            // $customUrl = "dev://yummyhose/{$id}/{$hash}?expires={$expires}&signature={$signature}";
            $customUrl = env('MOBILE_URL') .  "/verify/{$id}/{$hash}?expires={$expires}&signature={$signature}";

            return new CustomVerifyEmail($customUrl, $notifiable, $url);
        });
    }
}
