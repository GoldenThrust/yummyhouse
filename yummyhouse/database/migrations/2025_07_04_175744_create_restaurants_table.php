<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('restaurants', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('name');
            $table->text('description')->nullable();
            $table->string('image_url')->nullable();
            $table->string('banner_url')->nullable();
            $table->string('phone')->nullable();
            $table->string('email')->nullable();
            $table->string('website')->nullable();
            $table->text('address');
            $table->string('city');
            $table->string('state');
            $table->string('postal_code');
            $table->string('country')->default('US');
            $table->decimal('latitude', 10, 8)->nullable();
            $table->decimal('longitude', 11, 8)->nullable();
            $table->json('cuisine_type')->nullable();
            $table->enum('price_range', ['$', '$$', '$$$', '$$$$'])->default('$$');
            $table->decimal('rating', 3, 2)->default(0);
            $table->integer('review_count')->default(0);
            $table->integer('delivery_time')->nullable(); // in minutes
            $table->decimal('minimum_order', 8, 2)->default(0);
            $table->decimal('delivery_fee', 8, 2)->default(0);
            $table->boolean('is_open')->default(true);
            $table->boolean('is_active')->default(true);
            $table->json('opening_hours')->nullable();
            $table->decimal('delivery_radius', 8, 2)->default(10); // in km
            $table->boolean('featured')->default(false);
            $table->decimal('delivery_price', 8, 2)->nullable();
            $table->enum('delivery_price_type', ['fixed', 'percentage', 'free'])->default('fixed');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('restaurants');
    }
};
