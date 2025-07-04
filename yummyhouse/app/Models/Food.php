<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Food extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'description',
        'image_url',
        'category_id',
        'restaurant_id',
        'price',
        'discounted_price',
        'discounted_threshold_min',
        'discounted_threshold_max',
        'preparation_time',
        'is_available',
        'is_vegetarian',
        'is_vegan',
        'is_spicy',
        'allergens',
        'ingredients',
        'nutritional_info',
        'calories',
        'rating',
        'review_count'
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'discounted_price' => 'decimal:2',
        'preparation_time' => 'integer',
        'is_available' => 'boolean',
        'is_vegetarian' => 'boolean',
        'is_vegan' => 'boolean',
        'is_spicy' => 'boolean',
        'allergens' => 'array',
        'ingredients' => 'array',
        'nutritional_info' => 'array',
        'calories' => 'integer',
        'rating' => 'decimal:2',
        'review_count' => 'integer',
        'discounted_threshold_min' => 'decimal:2',
        'discounted_threshold_max' => 'decimal:2',
        'delivery_price' => 'decimal:2',
    ];

    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    public function restaurant()
    {
        return $this->belongsTo(Restaurant::class);
    }

    public function reviews()
    {
        return $this->hasMany(Review::class);
    }

    public function orderItems()
    {
        return $this->hasMany(OrderItem::class);
    }

    public function scopeAvailable($query)
    {
        return $query->where('is_available', true);
    }

    public function scopeVegetarian($query)
    {
        return $query->where('is_vegetarian', true);
    }

    public function scopeVegan($query)
    {
        return $query->where('is_vegan', true);
    }

    public function scopeOnSale($query)
    {
        return $query->whereNotNull('discounted_price')
            ->where('discounted_price', '<', 'price');
    }

    public function getDeliveryPriceAttribute()
    {
        if ($this->delivery_price_type === 'free') {
            return 0;
        }

        return $this->delivery_price;
    }

    public function getCurrentPriceAttribute()
    {
        return $this->discounted_price ?: $this->price;
    }

    public function getDiscountPercentageAttribute()
    {
        if (!$this->discounted_price || $this->discounted_price >= $this->price) {
            return 0;
        }

        return round((($this->price - $this->discounted_price) / $this->price) * 100);
    }
}
