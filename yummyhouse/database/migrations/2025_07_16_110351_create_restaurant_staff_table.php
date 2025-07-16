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
        Schema::create('restaurant_staff', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('restaurant_id')->constrained()->onDelete('cascade');
            $table->enum('role', ['manager', 'chef', 'cashier', 'waiter', 'kitchen_helper', 'delivery_person'])->default('waiter');
            $table->decimal('salary', 10, 2)->nullable();
            $table->enum('employment_type', ['full_time', 'part_time', 'contract'])->default('full_time');
            $table->date('hire_date');
            $table->date('end_date')->nullable();
            $table->enum('status', ['active', 'inactive', 'terminated'])->default('active');
            $table->text('notes')->nullable();
            $table->json('permissions')->nullable(); // Store specific permissions as JSON
            $table->timestamps();

            // Ensure a user can only be assigned once per restaurant
            $table->unique(['user_id', 'restaurant_id']);
            
            // Add indexes for better performance
            $table->index(['restaurant_id', 'status']);
            $table->index(['role', 'status']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('restaurant_staff');
    }
};
