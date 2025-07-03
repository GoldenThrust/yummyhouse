<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Address extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'type', # e.g., 'restaurant', 'pickup', 'delivery'
        'label', # e.g., 'Home', 'Work', 'Other'
        'street_address',
        'city',
        'state',
        'postal_code',
        // 'country',
        'latitude',
        'longitude',
        'is_default',
        'apartment_number',
        'building_name',
        'delivery_instructions'
    ];

    protected $casts = [
        'latitude' => 'decimal:8',
        'longitude' => 'decimal:8',
        'is_default' => 'boolean',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function orders()
    {
        return $this->hasMany(Order::class);
    }
}
